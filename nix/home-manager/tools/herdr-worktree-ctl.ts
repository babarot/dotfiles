#!/usr/bin/env -S deno run --allow-run=git,herdr,lsof,fzf,trash --allow-read --allow-write --allow-env
// herdr-worktree-ctl: list herdr's worktrees under ~/.herdr/worktrees with
// what tells whether one can go (an open space, uncommitted changes,
// processes working in it, commits not in the default branch, the last
// activity), and remove the ones picked with fzf. Closing a worktree space in
// herdr leaves its checkout and its git registration behind; this is what
// cleans them up.
//
// Every git command runs with -C on the worktree or its repository's main
// checkout, never on the caller's cwd. Spaces open in herdr are never
// removed, and just before each removal herdr's spaces and git status are
// read again, so a worktree reopened or edited while fzf was up is skipped.
// Folders that are not a working git worktree (orphans) are moved to the
// Trash, as git cannot tell what in them is uncommitted.
//
// No imports, so nothing is fetched when it runs.
// Tests: deno test -A herdr-worktree-ctl_test.ts

export const USAGE = `Usage: herdr-worktree-ctl <command> [options]

Commands:
  list              List herdr's worktrees, least recently active first
  delete            Pick worktrees with no open space with fzf and remove them

Options:
  --closed          list: only worktrees with no open space
  --branch          delete: also delete each worktree's branch (git branch -d)
  --orphans         delete: also offer folders that are not a working git
                    worktree, moved to the Trash
  -n, --dry-run     Show what would be done without doing it
  -h, --help        Show this help`;

export type Options = { closed: boolean; branch: boolean; orphans: boolean; dryRun: boolean };

// worktree: a linked git worktree; repo: a repository of its own (.git is a
// folder), never removed; no-git: no .git at all; broken: .git points to a
// gitdir that is gone
export type Kind = "worktree" | "repo" | "no-git" | "broken";

export type Proc = { pid: number; command: string; cwd: string };

export type Worktree = {
  path: string;
  repo: string;
  name: string;
  kind: Kind;
  main: string | null;
  branch: string | null;
  // "in main" (no commits beyond the default branch), "gone" (its upstream
  // was deleted), "+N" (commits only here), or the kind for the rest
  state: string;
  status: string;
  procs: Proc[];
  last: number;
  // the open space's id, null for none, "?" when herdr did not answer
  space: string | null;
};

export function base(): string {
  return `${Deno.env.get("HOME")}/.herdr/worktrees`;
}

async function run(cmd: string, args: string[], input?: string): Promise<string> {
  const child = new Deno.Command(cmd, {
    args,
    stdin: input === undefined ? "inherit" : "piped",
    stdout: "piped",
    stderr: "inherit",
  }).spawn();
  if (input !== undefined) {
    const w = child.stdin.getWriter();
    await w.write(new TextEncoder().encode(input));
    await w.close();
  }
  const { code, stdout } = await child.output();
  // fzf exits 1 when nothing matched and 130 when cancelled
  if (code !== 0 && !(cmd === "fzf" && (code === 1 || code === 130))) {
    throw new Error(`${cmd} ${args.join(" ")} exited with ${code}`);
  }
  return new TextDecoder().decode(stdout);
}

// For questions git answers with its exit code or may fail on: stderr is
// dropped and a failure returns null
async function tryGit(dir: string, args: string[]): Promise<string | null> {
  const { code, stdout } = await new Deno.Command("git", {
    args: ["-C", dir, ...args],
    stdin: "null",
    stdout: "piped",
    stderr: "null",
  }).output();
  return code === 0 ? new TextDecoder().decode(stdout).trimEnd() : null;
}

// Open spaces by checkout path; null when herdr does not answer
export async function spaces(): Promise<Map<string, string> | null> {
  try {
    type List = { result: { workspaces: { workspace_id: string; worktree?: { checkout_path?: string } }[] } };
    const list: List = JSON.parse(await run("herdr", ["workspace", "list"]));
    const m = new Map<string, string>();
    for (const w of list.result.workspaces) {
      const p = w.worktree?.checkout_path;
      if (p && !m.has(p)) m.set(p, w.workspace_id);
    }
    return m;
  } catch {
    return null;
  }
}

// Parses lsof -F pcn: a p line starts a process, then c is its command and
// n the file, here its cwd
export function parseLsof(out: string): Proc[] {
  const procs: Proc[] = [];
  let pid = 0, command = "";
  for (const line of out.split("\n")) {
    const v = line.slice(1);
    if (line[0] === "p") pid = Number(v);
    // Claude Code names its process by its version
    else if (line[0] === "c") command = /^\d+\.\d+\.\d+$/.test(v) ? "claude" : v;
    else if (line[0] === "n") procs.push({ pid, command, cwd: v });
  }
  return procs;
}

async function processes(): Promise<Proc[]> {
  // lsof exits 1 when some processes cannot be read, which is normal
  const { stdout } = await new Deno.Command("lsof", {
    args: ["-nP", "-d", "cwd", "-Fpcn"],
    stdin: "null",
    stdout: "piped",
    stderr: "null",
  }).output();
  return parseLsof(new TextDecoder().decode(stdout));
}

// The path itself or anything under it, not a sibling sharing its prefix
export function within(cwd: string, path: string): boolean {
  return cwd === path || cwd.startsWith(path + "/");
}

// Paths in git status --porcelain: "XY path", or "XY from -> to" for a rename
export function statusPaths(status: string): string[] {
  return status.split("\n").filter(Boolean).map((l) => {
    const p = l.slice(3);
    const i = p.indexOf(" -> ");
    return (i >= 0 ? p.slice(i + 4) : p).replace(/^"(.*)"$/, "$1");
  });
}

async function mtime(path: string): Promise<number> {
  try {
    return (await Deno.lstat(path)).mtime?.getTime() ?? 0;
  } catch {
    return 0;
  }
}

// The default branch to compare with, as the refs that hold it: the local
// branch, as worktrees here land in main before it is pushed, and
// origin's, as a local main left behind does not have what was merged
// through a PR. Its name comes from origin/HEAD, else main or master.
export async function defaultBranch(main: string): Promise<{ name: string; refs: string[] } | null> {
  const head = await tryGit(main, ["symbolic-ref", "--short", "refs/remotes/origin/HEAD"]);
  for (const name of [...(head ? [head.replace(/^origin\//, "")] : []), "main", "master"]) {
    const refs: string[] = [];
    for (const ref of [`refs/heads/${name}`, `refs/remotes/origin/${name}`]) {
      if (await tryGit(main, ["rev-parse", "--verify", "--quiet", `${ref}^{commit}`]) !== null) refs.push(ref);
    }
    if (refs.length > 0) return { name, refs };
  }
  return null;
}

// Without taking git's lock or refreshing the index, which would touch the
// worktree while herdr or an agent works in it
function status(path: string): Promise<string | null> {
  return tryGit(path, ["--no-optional-locks", "status", "--porcelain"]);
}

async function kindOf(path: string): Promise<{ kind: Kind; gitdir: string | null }> {
  let st;
  try {
    st = await Deno.lstat(`${path}/.git`);
  } catch {
    return { kind: "no-git", gitdir: null };
  }
  if (st.isDirectory) return { kind: "repo", gitdir: null };
  const m = (await Deno.readTextFile(`${path}/.git`)).match(/^gitdir: (.+)$/m);
  if (!m) return { kind: "broken", gitdir: null };
  const gitdir = m[1].startsWith("/") ? m[1] : `${path}/${m[1]}`;
  try {
    await Deno.stat(gitdir);
    return { kind: "worktree", gitdir };
  } catch {
    return { kind: "broken", gitdir: null };
  }
}

async function inspect(path: string, procs: Proc[], open: Map<string, string> | null): Promise<Worktree> {
  const parts = path.split("/");
  const wt: Worktree = {
    path,
    repo: parts[parts.length - 2],
    name: parts[parts.length - 1],
    kind: "no-git",
    main: null,
    branch: null,
    state: "",
    status: "",
    procs: procs.filter((p) => within(p.cwd, path)),
    last: 0,
    space: open ? open.get(path) ?? null : "?",
  };
  const { kind, gitdir } = await kindOf(path);
  wt.kind = kind;
  wt.state = kind;

  if (kind !== "worktree") {
    // No git to ask: the newest of the folder and what is right in it
    const times = [await mtime(path)];
    try {
      for await (const e of Deno.readDir(path)) times.push(await mtime(`${path}/${e.name}`));
    } catch { /* unreadable: the folder's own time */ }
    wt.last = Math.max(...times);
    return wt;
  }

  const common = await tryGit(path, ["rev-parse", "--path-format=absolute", "--git-common-dir"]);
  wt.main = common ? common.replace(/\/\.git\/?$/, "") : null;
  wt.branch = await tryGit(path, ["symbolic-ref", "--short", "HEAD"]);
  wt.status = await status(path) ?? "";

  const committed = Number(await tryGit(path, ["log", "-1", "--format=%ct"]) ?? 0) * 1000;
  // Not the index: git status rewrites it, and herdr runs that all the time
  const touched = await Promise.all([
    mtime(`${gitdir}/logs/HEAD`),
    ...statusPaths(wt.status).map((p) => mtime(`${path}/${p}`)),
  ]);
  wt.last = Math.max(committed, ...touched);

  const def = wt.main ? await defaultBranch(wt.main) : null;
  const ahead = def ? await tryGit(path, ["rev-list", "--count", "HEAD", "--not", ...def.refs]) : null;
  const track = wt.branch
    ? await tryGit(path, ["for-each-ref", "--format=%(upstream:track)", `refs/heads/${wt.branch}`])
    : null;
  if (ahead === "0") wt.state = `in ${def!.name}`;
  else if (track === "[gone]") wt.state = "gone";
  else if (ahead !== null) wt.state = `+${ahead}`;
  else wt.state = "?";
  return wt;
}

async function dirs(path: string): Promise<string[]> {
  const out: string[] = [];
  try {
    for await (const e of Deno.readDir(path)) if (e.isDirectory) out.push(`${path}/${e.name}`);
  } catch { /* none yet */ }
  return out.sort();
}

export async function collect(): Promise<Worktree[]> {
  const [procs, open] = await Promise.all([processes(), spaces()]);
  const paths = (await Promise.all((await dirs(base())).map(dirs))).flat();
  const wts = await Promise.all(paths.map((p) => inspect(p, procs, open)));
  return wts.sort((a, b) => a.last - b.last);
}

// Colors only on a terminal, and never with NO_COLOR
const color = Deno.stdout.isTerminal() && !Deno.noColor;
const paint = (code: number) => (s: string) => color ? `\x1b[${code}m${s}\x1b[0m` : s;
const red = paint(31), yellow = paint(33), green = paint(32), dim = paint(2), bold = paint(1);

export function age(ms: number, now = Date.now()): string {
  if (ms === 0) return "?";
  const mins = Math.floor((now - ms) / 60_000);
  if (mins < 60) return `${Math.max(mins, 0)}m`;
  if (mins < 60 * 24) return `${Math.floor(mins / 60)}h`;
  const days = Math.floor(mins / 60 / 24);
  if (days >= 30) return `${Math.floor(days / 30)}mo`;
  return `${days}d`;
}

// Pads by visible width, so painted cells still line up. The last column
// is not padded, so a long one does not widen the rest.
export function table(rows: string[][], right: Set<number> = new Set()): string {
  // deno-lint-ignore no-control-regex
  const width = (s: string) => s.replace(/\x1b\[[0-9;]*m/g, "").length;
  const widths = rows[0].map((_, i) => Math.max(...rows.map((r) => width(r[i]))));
  const last = rows[0].length - 1;
  return rows.map((r) =>
    r.map((cell, i) => {
      if (i === last) return cell;
      const pad = " ".repeat(widths[i] - width(cell));
      return right.has(i) ? pad + cell : cell + pad;
    }).join("  ").trimEnd()
  ).join("\n");
}

export function dirtyCount(wt: Worktree): number {
  return wt.status.split("\n").filter(Boolean).length;
}

const HEADER = ["SPACE", "REPO", "NAME", "BRANCH", "STATE", "DIRTY", "LAST", "PROCS"];
const RIGHT = new Set([5, 6]);

function rowOf(wt: Worktree): string[] {
  const dirty = dirtyCount(wt);
  const state = wt.state.startsWith("in ")
    ? green(wt.state)
    : wt.state.startsWith("+")
    ? yellow(wt.state)
    : red(wt.state);
  const commands = [...new Set(wt.procs.map((p) => p.command))].join(",");
  return [
    wt.space ?? dim("-"),
    wt.repo,
    wt.name,
    wt.branch ?? dim("-"),
    wt.kind === "worktree" ? state : red(wt.state),
    dirty > 0 ? yellow(`${dirty}`) : dim("0"),
    age(wt.last),
    commands ? yellow(commands) : dim("-"),
  ];
}

async function list(opts: Options) {
  const wts = (await collect()).filter((w) => !opts.closed || w.space === null);
  if (wts.length === 0) return console.log(dim(`No worktrees under ${base()}.`));
  console.log(table([HEADER, ...wts.map(rowOf)], RIGHT));
  if (wts.some((w) => w.space === "?")) console.log(red("herdr did not answer, so which spaces are open is unknown."));
}

// What delete offers: no open space, and a linked worktree, or with
// --orphans a folder that is not one. A repository of its own never.
export function candidate(wt: Worktree, orphans: boolean): boolean {
  if (wt.space !== null || wt.kind === "repo") return false;
  return wt.kind === "worktree" || orphans;
}

const PREVIEW_DOWN = "down,60%,border-top";
const PREVIEW_RIGHT = `right,50%,border-left,<60(${PREVIEW_DOWN})`;

// Lets the user pick worktrees with fzf, the one under the cursor shown in
// the preview; returns the paths picked. Each line starts with the path and
// a tab, which fzf hides and the preview reads.
async function pick(wts: Worktree[]): Promise<string[]> {
  const lines = table([HEADER.slice(1), ...wts.map((w) => rowOf(w).slice(1))], new Set([...RIGHT].map((i) => i - 1)))
    .split("\n");
  const input = lines.map((l, i) => `${i === 0 ? "PATH" : wts[i - 1].path}\t${l}`).join("\n") + "\n";
  const out = await run("fzf", [
    "--multi",
    "--ansi",
    // Down to the bottom of the terminal, keeping the line typed above;
    // FZF_DEFAULT_OPTS may give a smaller height
    "--height=-1",
    "--header-lines=1",
    "--delimiter=\t",
    "--with-nth=2",
    "--prompt=delete> ",
    "--header=TAB to select, Enter to confirm, ctrl-/ to move the preview, ctrl-d/u to scroll it",
    `--preview=${previewCommand()} {1}`,
    // On the right, or below when that would leave it under 60 columns
    `--preview-window=${PREVIEW_RIGHT}`,
    `--bind=ctrl-/:change-preview-window(${PREVIEW_DOWN}|hidden|${PREVIEW_RIGHT})`,
    // In place of clearing the query (ctrl-u) and deleting a character (ctrl-d)
    "--bind=ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up",
  ], input);
  return out.split("\n").filter(Boolean).map((l) => l.split("\t")[0]);
}

// fzf runs the preview through the shell, so the script calls itself, with
// the deno running it and only what the preview needs
export function previewCommand(): string {
  const self = [
    Deno.execPath(),
    "run",
    "--ext=ts",
    "--allow-run=git,lsof",
    "--allow-read",
    "--allow-env",
    import.meta.filename!,
    "__preview",
  ];
  return self.map((a) => `'${a.replaceAll("'", `'\\''`)}'`).join(" ");
}

// Prints a worktree for the preview: git status and the commits not in the
// default branch, or for an orphan what is in it; then its processes
async function preview(path: string) {
  const wt = await inspect(path, await processes(), new Map());
  const out = (s: string) => Deno.stdout.write(new TextEncoder().encode(s + "\n"));
  // fzf shows colors in the preview, though stdout is not a terminal
  const head = (s: string) => out(`\x1b[1m${s}\x1b[0m`);
  await head(path);
  await out("");
  if (wt.kind === "worktree") {
    await head("Status");
    await out(await tryGit(path, ["--no-optional-locks", "-c", "color.status=always", "status", "-sb"]) ?? "");
    const def = wt.main ? await defaultBranch(wt.main) : null;
    if (def) {
      await out("");
      await head(`Commits not in ${def.name}`);
      await out(
        await tryGit(path, ["log", "--color=always", "--oneline", "-20", "HEAD", "--not", ...def.refs]) || "(none)",
      );
    }
  } else {
    await head(`Not a working git worktree (${wt.kind}); its contents:`);
    const names: string[] = [];
    for await (const e of Deno.readDir(path)) names.push(e.isDirectory ? `${e.name}/` : e.name);
    await out(names.sort().join("\n") || "(empty)");
  }
  await out("");
  await head("Processes working in it");
  await out(wt.procs.map((p) => `${p.pid}  ${p.command}  ${p.cwd}`).join("\n") || "(none)");
}

// Reads one line from stdin; prompt() would return null when stdin is not a
// terminal
async function confirm(word: string): Promise<boolean> {
  await Deno.stdout.write(new TextEncoder().encode(`Type "${word}" to continue: `));
  const buf = new Uint8Array(1024);
  const n = await Deno.stdin.read(buf);
  const answer = n === null ? "" : new TextDecoder().decode(buf.subarray(0, n)).split("\n")[0].trim();
  return answer === word;
}

// A folder right under ~/.herdr/worktrees/<repo>/, with links resolved, so a
// removal never reaches anywhere else
export async function underBase(path: string): Promise<boolean> {
  try {
    const [real, root] = await Promise.all([Deno.realPath(path), Deno.realPath(base())]);
    const rest = real.slice(root.length + 1).split("/");
    return real.startsWith(root + "/") && rest.length === 2 && !rest.includes("..");
  } catch {
    return false;
  }
}

// The commands that remove a worktree, as [command, args]
export function removal(wt: Worktree, branch: boolean): [string, string[]][] {
  if (wt.kind !== "worktree" || !wt.main) return [["trash", [wt.path]]];
  const cmds: [string, string[]][] = [["git", ["-C", wt.main, "worktree", "remove", "--force", wt.path]]];
  if (branch && wt.branch) cmds.push(["git", ["-C", wt.main, "branch", "-d", wt.branch]]);
  return cmds;
}

// Why a worktree must not be removed now, read again just before; null when
// it can go
async function blocker(wt: Worktree): Promise<string | null> {
  if (!(await underBase(wt.path))) return `not right under ${base()}`;
  const open = await spaces();
  if (!open) return "herdr did not answer, so whether a space is open is unknown";
  if (open.has(wt.path)) return `a space is open on it now (${open.get(wt.path)})`;
  if (wt.kind === "worktree") {
    const now = await status(wt.path);
    if (now === null) return "git status failed";
    if (now !== wt.status) return "its changes differ from what was shown";
  }
  return null;
}

async function del(opts: Options) {
  const all = await collect();
  if (all.some((w) => w.space === "?")) throw new Error("herdr did not answer, so which spaces are open is unknown");
  const wts = all.filter((w) => candidate(w, opts.orphans));
  if (wts.length === 0) return console.log("No worktree without an open space.");
  const paths = await pick(wts);
  if (paths.length === 0) return;

  const picked = wts.filter((w) => paths.includes(w.path));
  console.log(bold(`Remove ${picked.length} worktrees:`));
  console.log(table([HEADER, ...picked.map(rowOf)], RIGHT).split("\n").map((l) => `  ${l}`).join("\n"));
  const dirty = picked.filter((w) => w.kind === "worktree" && dirtyCount(w) > 0);
  if (dirty.length > 0) console.log(red(`Uncommitted changes in ${dirty.map((w) => w.name).join(", ")} are lost.`));
  const busy = picked.filter((w) => w.procs.length > 0);
  if (busy.length > 0) {
    console.log(red(`Processes keep running in ${busy.map((w) => w.name).join(", ")}, with their folder gone.`));
  }
  const ahead = picked.filter((w) => w.state.startsWith("+") || w.state === "gone");
  if (ahead.length > 0) {
    console.log(red(
      `Commits not in the default branch: ${ahead.map((w) => w.name).join(", ")}; ` +
        (opts.branch ? "git branch -d keeps their branches." : "their branches stay."),
    ));
  }
  const orphans = picked.filter((w) => w.kind !== "worktree");
  if (orphans.length > 0) {
    console.log(red(`Moved to the Trash, unchecked by git: ${orphans.map((w) => w.name).join(", ")}.`));
  }
  if (!opts.dryRun && !(await confirm("delete"))) return console.log("Cancelled.");

  let failed = 0;
  const repos = new Set<string>();
  for (const wt of picked) {
    if (opts.dryRun) {
      for (const [cmd, args] of removal(wt, opts.branch)) console.log(dim(`would run: ${cmd} ${args.join(" ")}`));
      continue;
    }
    const why = await blocker(wt);
    if (why) {
      failed++;
      console.error(red(`skipped: ${wt.path}: ${why}`));
      continue;
    }
    try {
      const [first, ...rest] = removal(wt, opts.branch);
      await run(...first);
      console.log(`removed: ${wt.path}`);
      if (wt.main) repos.add(wt.main);
      for (const cmd of rest) {
        try {
          await run(...cmd);
          console.log(`deleted branch: ${wt.branch}`);
        } catch {
          console.error(yellow(`kept branch: ${wt.branch} (not merged)`));
        }
      }
    } catch {
      failed++;
      console.error(red(`failed: ${wt.path}`));
    }
  }
  if (opts.dryRun) return;
  for (const main of repos) await tryGit(main, ["worktree", "prune"]);
  // Repo folders left empty; removing without recursive fails on any other
  for (const dir of await dirs(base())) await Deno.remove(dir).catch(() => {});
  if (failed > 0) throw new Error(`${failed} of ${picked.length} failed`);
}

// Throws on an argument it does not know; help is reported, not printed
export function parse(args: string[]): { command?: string; help: boolean; opts: Options } {
  const opts: Options = { closed: false, branch: false, orphans: false, dryRun: false };
  let command: string | undefined;
  let help = false;
  for (const a of args) {
    switch (a) {
      case "--closed":
        opts.closed = true;
        break;
      case "--branch":
        opts.branch = true;
        break;
      case "--orphans":
        opts.orphans = true;
        break;
      case "-n":
      case "--dry-run":
        opts.dryRun = true;
        break;
      case "-h":
      case "--help":
        help = true;
        break;
      default:
        if (a.startsWith("-") || command) throw new Error(`unknown argument: ${a}`);
        command = a;
    }
  }
  return { command, help, opts };
}

const commands: Record<string, (opts: Options) => Promise<void>> = { list, delete: del };

async function main(args: string[]): Promise<number> {
  if (args[0] === "__preview") {
    try {
      await preview(args[1]);
      return 0;
    } catch (e) {
      console.error(e instanceof Error ? e.message : e);
      return 1;
    }
  }
  let parsed;
  try {
    parsed = parse(args);
  } catch (e) {
    console.error(`herdr-worktree-ctl: ${(e as Error).message}\n\n${USAGE}`);
    return 2;
  }
  const { command, help, opts } = parsed;
  if (help) {
    console.log(USAGE);
    return 0;
  }
  if (!command || !(command in commands)) {
    console.error(command ? `herdr-worktree-ctl: unknown command: ${command}\n\n${USAGE}` : USAGE);
    return 2;
  }
  try {
    await commands[command](opts);
    return 0;
  } catch (e) {
    console.error(red(`herdr-worktree-ctl: ${e instanceof Error ? e.message : e}`));
    return 1;
  }
}

if (import.meta.main) Deno.exit(await main(Deno.args));
