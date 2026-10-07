# Write a command of your own in a gist

How to decide whether a command of your own may live in a gist, and how to write, test, install and change one so it works like the ones already there: [deadlink](https://gist.github.com/babarot/5a253e61a992d99a5a5834d092dd25cd), [gist-ctl](https://gist.github.com/babarot/0bf79c7778a99d6ac5298ae61ab4b953), [repo-cleanup](https://gist.github.com/babarot/c2c3436e248b21ee3c542dc3b8ead46a) and [herdr-worktree-ctl](https://gist.github.com/babarot/d7b198c8e7f26189e46f80e46053ff29). Fetching a file from any git host in general is [install-from-git.md](./install-from-git.md); this page is about commands you write yourself.

## Should it be a gist

A gist is one way to keep a script of your own. It is allowed when all of these hold:

| Condition | Why | If not |
|---|---|---|
| It has settled: what it does and its interface no longer change every few minutes | Every edit to a gist takes a push, `nix flake update` and a switch before it runs | Keep shaping it in `~/bin` ([below](#1-shape-it-in-bin)) |
| It is a command, run on its own | A gist holds programs; a function that changes the shell (`cd`, `export`, zle), a plugin that is sourced, or a config is not one | A function in its tool's file, a plugin ([install-from-git.md](./install-from-git.md#a-plugin-that-is-sourced)), a config in `home/` |
| It stands alone: its files and tests are all it needs, and it reads nothing from this repo | A gist has no directories and is fetched as its own input; it cannot see this repo | Keep it in the repo, next to the file that uses it (`herdr/worktree-status.sh`) |
| It is safe to publish | Gists here are public. A secret gist is still readable by anyone with its URL, and a public one cannot be made secret again | Keep it out of the gist; anything with work names or credentials stays out of this public repo too |
| It is big enough to be worth its own history, usually because it has tests | A few lines of bash belonging to a tool are clearer inline in that tool's file | `pkgs.writeShellApplication` with the text inline (`git-url` in `git.nix`) |

What a gist gives over the repo: the script has its own history, out of this repo's; it can be fetched with `curl` on a machine without Nix; and one gist is one flake input and one line in `flake.lock`, so updating one moves no other. A repository collecting many small scripts would be one input, and updating it would move them all.

What it costs: an edit is not live until it is pushed, taken in with `nix flake update <name>` and switched; and deleting the gist (gist-ctl can) breaks the build on a Mac that has not fetched it yet. `flake.lock` pins a commit, so nothing changes here until you update.

### Where its Nix goes

The gist holds the script; a `.nix` file in this repo builds it. Which file follows [One file, one lifecycle](../../AGENTS.md#cohesion-one-file-one-lifecycle) as for any tool:

- It belongs to no tool: its own `nix/home-manager/tools/<name>.nix` ([deadlink.nix](../../nix/home-manager/tools/deadlink.nix), [gist-ctl.nix](../../nix/home-manager/tools/gist-ctl.nix), [repo-cleanup.nix](../../nix/home-manager/tools/repo-cleanup.nix)).
- It exists only for one tool (a companion: "if the tool were removed, would I keep this?" no): built in that tool's file, so deleting the tool's file removes it ([herdr.nix](../../nix/home-manager/tools/herdr.nix) builds herdr-worktree-ctl).
- It is for a subject that has a set: in the set.
- For one Mac only: `nix/hosts/<host>/<name>.nix`.

## Bash or Deno

| | Bash | Deno |
|---|---|---|
| Use for | a short script with no UI and no tests | anything with JSON, tables, fzf pickers, or tests |
| Gist holds | `<name>`, with `#!/usr/bin/env bash` | `<name>.ts` and `<name>_test.ts` |
| Nix builds it with | `pkgs.writeShellApplication` and `builtins.readFile`; shellcheck runs at build time | `pkgs.runCommand`: `deno test`, then `makeWrapper` around `deno run` |
| Example | deadlink | gist-ctl, repo-cleanup, herdr-worktree-ctl |

The rest of this page is about Deno, which is what a new command should normally use. Name the files with `.ts`, so editors and `deno` know what they are without a filetype rule.

## 1. Shape it in ~/bin

Write the script as `~/bin/<name>.ts` and run it from there while you decide what it does. `~/bin` is `home/bin` in this repo, linked and on PATH, and git ignores everything in it, so nothing is committed by accident. deno is on PATH from `packages.nix`.

```bash
deno run --allow-all ~/bin/<name>.ts list
deno check ~/bin/<name>.ts && deno lint ~/bin/<name>.ts && deno fmt --line-width=120 ~/bin/<name>.ts
```

Write the tests only once the shape has settled; until then they would be rewritten with every change.

## 2. Write it to the conventions

Read [gist-ctl.ts](https://gist.github.com/babarot/0bf79c7778a99d6ac5298ae61ab4b953) once before writing; the others are built the same way, and copying its helpers is the intended start: `run` and `ghCommand` (outside commands), `table` and `width` (aligned output), `pick`, `previewCommand` and `preview` (the fzf picker), `confirm`, `parse` and `main`. Its test file gives `assert`, `assertEquals` and the fake commands. What they share:

- A header comment: what it does, and anything a reader needs to trust it (what it never touches, what it asks before doing). Then `USAGE` as an exported constant.
- No imports, not even `jsr:@std`. Nothing is fetched when it runs, so nothing escapes `flake.lock`, and the tests run offline in the Nix sandbox. Small helpers (`assertEquals`, a table printer) are written in the file.
- Every outside command goes through one `run(cmd, args, input?)` helper built on `Deno.Command`, which throws on a non-zero exit (fzf's 1 and 130, nothing picked or cancelled, are not failures). Commands are run by name; the wrapper's PATH decides which one ([step 5](#5-build-it-in-nix)).
- UI plumbing goes to tools made for it, not into the script: a spinner is `gum spin --show-stdout --show-error -- gh ...`, run only when stderr is a terminal (gum writes its control codes into a pipe too); a picker is fzf.
- An fzf picker puts a hidden key first on each line (`<id>\t<row>`, `--delimiter=\t --with-nth=2`) and reads it back from what fzf prints. Its preview calls the script itself through a hidden subcommand, `__preview <id>`, with `Deno.execPath()` and `import.meta.filename`, so it runs the same deno and the same file, with only the permissions the preview needs (`previewCommand` in gist-ctl.ts).
- Anything that changes or deletes asks first: it shows what will happen, with warnings in red, and asks for a word to be typed (`delete`), read from stdin, since `prompt()` returns null when stdin is not a terminal. `-n`/`--dry-run` prints the commands instead and asks nothing.
- Colors only when stdout is a terminal and `NO_COLOR` is unset (`Deno.stdout.isTerminal() && !Deno.noColor`). fzf's preview shows colors although its stdout is a pipe, so the preview writes them unconditionally.
- `parse(args)` throws on an unknown argument; `main(args)` returns the exit code: 0, 1 for a failure (a batch carries on past one failed item and exits 1 at the end), 2 for a usage error. The file ends with `if (import.meta.main) Deno.exit(await main(Deno.args));`, so the tests can import it.
- Export the pure functions (parsing, formatting, deciding), so tests call them directly.
- Anything that removes or rewrites state re-reads that state just before acting, and skips what changed while the picker or the prompt was up (herdr-worktree-ctl re-reads herdr's spaces and `git status`).

## 3. Write the tests

The tests pin down behavior, so a later edit that breaks it fails to build. `<name>_test.ts` sits next to the script in the gist and imports it with a relative path.

- Pure functions are called directly.
- Commands are run as they are, as a child process (`Deno.execPath()` `run --allow-all <script>`), against fake versions of the outside commands written into a temporary directory put first on PATH. A fake answers from fixtures (an env var or a JSON file), records its arguments to a file the test reads back, and for fzf picks the rows whose key is in an env var. gist-ctl's fake gh is a small Deno script that answers REST and GraphQL with two items a page, so paging is tested too.
- When the real thing is cheap and deterministic, use it instead of a fake: herdr-worktree-ctl's tests create real git repositories and worktrees in a temporary `HOME`, with `GIT_CONFIG_GLOBAL=/dev/null` and the author and committer set in the environment.
- Not tested: what only a terminal shows (the spinner, fzf's own UI). Check those by hand.

Run them:

```bash
deno test --allow-all ~/bin/<name>_test.ts
```

Then check that the tests can fail: break the script on purpose in a few ways that matter (skip the confirmation, act during a dry run, drop a filter, pick the wrong row) and see each one fail a test, then undo. gist-ctl was checked with eight such breaks, repo-cleanup with six. A test that never fails pins nothing.

## 4. Create the gist

```bash
cd ~/bin
gh gist create --public -d "<name>: <one line on what it does>" <name>.ts <name>_test.ts
```

The description reads like the others: the command's name, a colon, what it does. Then add it to [flake.nix](../../flake.nix), alphabetically among the gist inputs, and lock it:

```nix
<name> = {
  url = "git+https://gist.github.com/babarot/<id>.git";
  flake = false;
};
```

```bash
nix flake update <name>
```

## 5. Build it in Nix

[repo-cleanup.nix](../../nix/home-manager/tools/repo-cleanup.nix) is the whole pattern; copy it and change the names. What each part is for:

```nix
(pkgs.runCommand "<name>"
  {
    nativeBuildInputs = [
      pkgs.deno
      pkgs.makeWrapper
      # anything the tests run for real, e.g. pkgs.git
    ];
  }
  ''
    # The sandbox has no writable HOME, and deno caches under it
    export HOME=$TMPDIR DENO_DIR=$TMPDIR/deno
    deno test --allow-all --no-lock ${inputs.<name>}/<name>_test.ts

    makeWrapper ${lib.getExe pkgs.deno} $out/bin/<name> \
      --add-flags "run --no-lock --allow-run=gh,fzf ${inputs.<name>}/<name>.ts" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.gh pkgs.fzf ]}
  '')
```

- The tests run in the build, so an edit that breaks them does not build, on either Mac.
- `deno run` on the file in the store, never `deno compile`: Nix strips binaries, which breaks compiled Deno ones.
- `--no-lock`: there are no imports to lock, so Deno is told not to look for or write a `deno.lock`.
- `--allow-run` lists the commands by name and nothing else; add `--allow-read`, `--allow-write`, `--allow-env` only if the script needs them.
- `--prefix PATH` puts the commands it runs first, so the versions pinned here win over any other on PATH. Each command in `--allow-run` is either here or macOS's own (git, lsof, trash). A tool from another tool file is passed by its package here, never assumed on PATH ([Loose coupling](../../AGENTS.md#loose-coupling-dependencies-between-tools)); a companion takes its main tool from its own file (`herdr` in herdr.nix).
- The header comment of the `.nix` says what the command does, that the script lives in a gist, which input, and that `nix flake update <name>` takes an edit.

Then build both Macs, run the built command, and land:

```bash
nix build .#darwinConfigurations.pro23.system --no-link
nix build .#darwinConfigurations.PC-M-2025-026.system --no-link
"$(nix build .#darwinConfigurations.pro23.config.home-manager.users.babarot.home.path --no-link --print-out-paths)/bin/<name>" --help
```

Delete `~/bin/<name>.ts` (and `_test.ts`) once the Nix one is in: `~/bin` comes first on PATH, and a stale copy there would hide the built one.

## Change one that exists

Edit a clone of the gist, try it, and push only once it works:

```bash
gh gist clone <id> /tmp/<name>
cd /tmp/<name>
# edit, then
deno test --allow-all <name>_test.ts
deno run --allow-all <name>.ts ...
```

To try the change built by Nix, with the build-time tests and the wrapper, before pushing anything, build with the input pointed at the clone. `--override-input` changes nothing in `flake.lock`, and `path:` takes the files as they are, committed or not:

```bash
cd ~/src/github.com/babarot/dotfiles   # or a worktree of it
out=$(nix build .#darwinConfigurations.pro23.config.home-manager.users.babarot.home.path \
  --override-input <name> path:/tmp/<name> --no-link --print-out-paths)
"$out/bin/<name>" ...
```

When it works, take it in:

```bash
cd /tmp/<name> && git commit -am "<what changed>" && git push
cd <dotfiles worktree> && nix flake update <name>
```

Build both Macs, land the `flake.lock` change, and switch. A change that also needs the `.nix` (a new command on PATH, a new permission) goes in the same commit as the lock update.

## Remove one

Delete its `.nix` file (or its lines in the tool's file it is built in) and its input in `flake.nix`, then `nix flake lock`, which drops it from `flake.lock`. Delete the gist afterwards, if at all: other Macs still on the old commit fetch it until they pull.
