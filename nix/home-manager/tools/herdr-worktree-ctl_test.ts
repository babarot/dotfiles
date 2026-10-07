// Tests for herdr-worktree-ctl: deno test -A herdr-worktree-ctl_test.ts
//
// The pure parts are tested directly. The commands run as they are, against
// real git repositories in a temporary HOME and a fake herdr, lsof, fzf and
// trash put first on PATH: herdr answers workspace list from FAKE_SPACES,
// lsof prints FAKE_LSOF, fzf picks the rows whose path ends in a name in
// FAKE_PICK, and trash records its argument and removes it. No imports
// beyond the script, so the tests run offline.

import {
  age,
  candidate,
  parse,
  parseLsof,
  removal,
  statusPaths,
  table,
  USAGE,
  within,
  type Worktree,
} from "./herdr-worktree-ctl.ts";

function assert(cond: unknown, message = "assertion failed"): asserts cond {
  if (!cond) throw new Error(message);
}

function assertEquals(actual: unknown, expected: unknown) {
  const a = JSON.stringify(actual), e = JSON.stringify(expected);
  assert(a === e, `expected ${e}\n  actual ${a}`);
}

function assertMatch(text: string, re: RegExp) {
  assert(re.test(text), `expected to match ${re} in:\n${text}`);
}

function assertNotMatch(text: string, re: RegExp) {
  assert(!re.test(text), `expected not to match ${re} in:\n${text}`);
}

const SCRIPT = new URL("./herdr-worktree-ctl.ts", import.meta.url).pathname;

const wt = (over: Partial<Worktree>): Worktree => ({
  path: "/h/.herdr/worktrees/r/a",
  repo: "r",
  name: "a",
  kind: "worktree",
  main: "/src/r",
  branch: "a",
  state: "in main",
  status: "",
  procs: [],
  last: 0,
  space: null,
  ...over,
});

Deno.test("parse reads commands and options", () => {
  assertEquals(parse(["delete", "-n", "--branch", "--orphans"]), {
    command: "delete",
    help: false,
    opts: { closed: false, branch: true, orphans: true, dryRun: true },
  });
  assertEquals(parse(["list", "--closed"]).opts.closed, true);
  assertEquals(parse(["-h"]).help, true);
  let threw = false;
  try {
    parse(["list", "--bogus"]);
  } catch {
    threw = true;
  }
  assert(threw, "an unknown option throws");
  assertMatch(USAGE, /delete/);
});

Deno.test("parseLsof pairs each cwd with its process, naming Claude Code by its version", () => {
  const out = "p10\nczsh\nfcwd\nn/a/b\np11\nc2.1.291\nfcwd\nn/a/c\n";
  assertEquals(parseLsof(out), [
    { pid: 10, command: "zsh", cwd: "/a/b" },
    { pid: 11, command: "claude", cwd: "/a/c" },
  ]);
});

Deno.test("within does not match a sibling sharing a prefix", () => {
  assert(within("/w/a", "/w/a"));
  assert(within("/w/a/sub", "/w/a"));
  assert(!within("/w/ab", "/w/a"));
});

Deno.test("statusPaths takes the new name of a rename", () => {
  assertEquals(statusPaths(' M a.txt\nR  old -> new\n?? "sp ace"\n'), ["a.txt", "new", "sp ace"]);
});

Deno.test("age", () => {
  const now = Date.parse("2026-10-07T00:00:00Z");
  assertEquals(age(0, now), "?");
  assertEquals(age(now - 5 * 60_000, now), "5m");
  assertEquals(age(now - 3 * 3_600_000, now), "3h");
  assertEquals(age(now - 4 * 86_400_000, now), "4d");
  assertEquals(age(now - 65 * 86_400_000, now), "2mo");
});

Deno.test("table pads by visible width", () => {
  assertEquals(
    table([["A", "B", "C"], ["\x1b[31mxx\x1b[0m", "1", "z"]], new Set([1])),
    "A   B  C\n\x1b[31mxx\x1b[0m  1  z",
  );
});

Deno.test("candidate leaves out open spaces and repositories, and orphans unless asked", () => {
  assert(candidate(wt({}), false));
  assert(!candidate(wt({ space: "w1" }), false));
  assert(!candidate(wt({ space: "?" }), true));
  assert(!candidate(wt({ kind: "repo" }), true));
  assert(!candidate(wt({ kind: "no-git" }), false));
  assert(candidate(wt({ kind: "broken" }), true));
});

Deno.test("removal runs git on the main checkout, and trashes orphans", () => {
  assertEquals(removal(wt({}), true), [
    ["git", ["-C", "/src/r", "worktree", "remove", "--force", "/h/.herdr/worktrees/r/a"]],
    ["git", ["-C", "/src/r", "branch", "-d", "a"]],
  ]);
  assertEquals(removal(wt({ kind: "no-git", main: null }), true), [["trash", ["/h/.herdr/worktrees/r/a"]]]);
});

// A temporary HOME with one repository and these under
// ~/.herdr/worktrees/r: merged (no commits of its own), ahead (one commit),
// dirty (an uncommitted file), open (a space is open on it), orphan (no
// .git) and standalone (a repository of its own)
async function fixture() {
  const home = await Deno.makeTempDir();
  const bin = `${home}/bin`;
  const main = `${home}/src/r`;
  const wts = `${home}/.herdr/worktrees/r`;
  const env: Record<string, string> = {
    HOME: home,
    PATH: `${bin}:${Deno.env.get("PATH")}`,
    NO_COLOR: "1",
    GIT_CONFIG_GLOBAL: "/dev/null",
    GIT_CONFIG_NOSYSTEM: "1",
    GIT_AUTHOR_NAME: "t",
    GIT_AUTHOR_EMAIL: "t@example.com",
    GIT_COMMITTER_NAME: "t",
    GIT_COMMITTER_EMAIL: "t@example.com",
  };
  const git = async (dir: string, ...args: string[]) => {
    const { code, stderr } = await new Deno.Command("git", { args: ["-C", dir, ...args], env }).output();
    assert(code === 0, `git ${args.join(" ")}: ${new TextDecoder().decode(stderr)}`);
  };

  await Deno.mkdir(main, { recursive: true });
  await Deno.mkdir(bin);
  await git(main, "init", "-q", "-b", "main");
  await git(main, "commit", "-q", "--allow-empty", "-m", "first");
  for (const name of ["merged", "ahead", "dirty", "open"]) {
    await git(main, "worktree", "add", "-q", "-b", name, `${wts}/${name}`);
  }
  await git(`${wts}/ahead`, "commit", "-q", "--allow-empty", "-m", "only here");
  await Deno.writeTextFile(`${wts}/dirty/new.txt`, "x");
  await Deno.mkdir(`${wts}/orphan`);
  await Deno.writeTextFile(`${wts}/orphan/left.txt`, "x");
  await Deno.mkdir(`${wts}/standalone`);
  await git(`${wts}/standalone`, "init", "-q");

  const sh = (name: string, body: string) =>
    Deno.writeTextFile(`${bin}/${name}`, `#!/bin/sh\n${body}\n`, { mode: 0o755 });
  await sh("herdr", `printf '%s' "$FAKE_SPACES"`);
  await sh("lsof", `printf '%s' "$FAKE_LSOF"`);
  await sh(
    "fzf",
    `
    cat > "$HOME/fzf-input"
    tab=$(printf '\\t')
    for name in $(echo "$FAKE_PICK" | tr , ' '); do grep "/$name$tab" "$HOME/fzf-input"; done
    exit 0`,
  );
  await sh("trash", `echo "$1" >> "$HOME/trashed"; rm -rf "$1"`);

  env.FAKE_SPACES = JSON.stringify({
    result: { workspaces: [{ workspace_id: "w9", worktree: { checkout_path: `${wts}/open` } }] },
  });
  env.FAKE_LSOF = `p42\nczsh\nfcwd\nn${wts}/merged/sub\n`;
  return { home, main, wts, env, git };
}

async function cli(env: Record<string, string>, args: string[], input = "") {
  const child = new Deno.Command(Deno.execPath(), {
    args: ["run", "--allow-all", SCRIPT, ...args],
    env,
    stdin: "piped",
    stdout: "piped",
    stderr: "piped",
  }).spawn();
  const w = child.stdin.getWriter();
  await w.write(new TextEncoder().encode(input));
  await w.close();
  const { code, stdout, stderr } = await child.output();
  const d = new TextDecoder();
  return { code, out: d.decode(stdout), err: d.decode(stderr) };
}

const exists = (p: string) => Deno.lstat(p).then(() => true, () => false);

Deno.test("list shows each worktree's space, state, changes and processes", async () => {
  const { home, env } = await fixture();
  try {
    const { code, out } = await cli(env, ["list"]);
    assertEquals(code, 0);
    assertMatch(out, /^w9\s+r\s+open\s+open\s+in main/m);
    assertMatch(out, /^-\s+r\s+merged\s+merged\s+in main\s+0\s+\S+\s+zsh$/m);
    assertMatch(out, /^-\s+r\s+ahead\s+ahead\s+\+1\s+0/m);
    assertMatch(out, /^-\s+r\s+dirty\s+dirty\s+in main\s+1/m);
    assertMatch(out, /^-\s+r\s+orphan\s+-\s+no-git/m);
    assertMatch(out, /^-\s+r\s+standalone\s+-\s+repo/m);

    const closed = await cli(env, ["list", "--closed"]);
    assertNotMatch(closed.out, /open/);
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});

Deno.test("list says when herdr does not answer", async () => {
  const { home, env } = await fixture();
  try {
    const { out } = await cli({ ...env, FAKE_SPACES: "not json" }, ["list"]);
    assertMatch(out, /^\?\s+r\s+merged/m);
    assertMatch(out, /herdr did not answer/);
    const del = await cli({ ...env, FAKE_SPACES: "not json" }, ["delete"]);
    assertEquals(del.code, 1);
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});

Deno.test("delete offers only closed worktrees, and orphans with --orphans", async () => {
  const { home, env } = await fixture();
  try {
    await cli({ ...env, FAKE_PICK: "" }, ["delete"]);
    const offered = await Deno.readTextFile(`${home}/fzf-input`);
    for (const n of ["merged", "ahead", "dirty"]) assertMatch(offered, new RegExp(`/${n}\t`));
    for (const n of ["open", "orphan", "standalone"]) assertNotMatch(offered, new RegExp(`/${n}\t`));

    await cli({ ...env, FAKE_PICK: "" }, ["delete", "--orphans"]);
    assertMatch(await Deno.readTextFile(`${home}/fzf-input`), /\/orphan\t/);
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});

Deno.test("delete -n changes nothing", async () => {
  const { home, wts, env } = await fixture();
  try {
    const { code, out } = await cli({ ...env, FAKE_PICK: "merged,orphan" }, ["delete", "-n", "--orphans", "--branch"]);
    assertEquals(code, 0);
    assertMatch(out, /would run: git -C \S+ worktree remove --force \S+\/merged/);
    assertMatch(out, /would run: git -C \S+ branch -d merged/);
    assertMatch(out, /would run: trash \S+\/orphan/);
    assert(await exists(`${wts}/merged`) && await exists(`${wts}/orphan`));
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});

Deno.test("delete asks for the word, then removes worktrees, branches and orphans", async () => {
  const { home, main, wts, env } = await fixture();
  try {
    const pick = { ...env, FAKE_PICK: "merged,ahead,dirty,orphan" };
    const cancelled = await cli(pick, ["delete", "--orphans", "--branch"], "no\n");
    assertMatch(cancelled.out, /Cancelled/);
    assert(await exists(`${wts}/merged`));

    const { code, out, err } = await cli(pick, ["delete", "--orphans", "--branch"], "delete\n");
    assertEquals(code, 0);
    assertMatch(out, /Uncommitted changes in dirty are lost/);
    assertMatch(out, /Processes keep running in merged/);
    assertMatch(out, /Commits not in the default branch: ahead/);
    for (const n of ["merged", "ahead", "dirty", "orphan"]) assert(!(await exists(`${wts}/${n}`)), `${n} removed`);
    assert(await exists(`${wts}/open`) && await exists(`${wts}/standalone`));
    assertMatch(await Deno.readTextFile(`${home}/trashed`), /\/orphan$/m);
    // merged and dirty had no commits of their own, so -d deletes them;
    // ahead's branch stays
    assertMatch(err, /kept branch: ahead/);
    const branches = new TextDecoder().decode(
      (await new Deno.Command("git", { args: ["-C", main, "branch", "--format=%(refname:short)"], env }).output())
        .stdout,
    );
    assertEquals(branches.trim().split("\n").sort(), ["ahead", "main", "open"]);
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});

Deno.test("delete skips a worktree whose changes differ from what was shown", async () => {
  const { home, wts, env } = await fixture();
  try {
    // fzf, which runs between the scan and the removal, edits the worktree
    await Deno.writeTextFile(
      `${home}/bin/fzf`,
      `#!/bin/sh\ncat > /dev/null\necho changed > "${wts}/merged/later.txt"\nprintf '%s\\tx\\n' "${wts}/merged"\n`,
      { mode: 0o755 },
    );
    const { code, err } = await cli(env, ["delete"], "delete\n");
    assertEquals(code, 1);
    assertMatch(err, /skipped: \S+\/merged: its changes differ/);
    assert(await exists(`${wts}/merged/later.txt`));
  } finally {
    await Deno.remove(home, { recursive: true });
  }
});
