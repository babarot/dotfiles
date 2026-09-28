---
name: nvim-plugin-audit
description: Audit the Neovim plugins in this dotfiles repo one by one. Researches what current Neovim already covers and each plugin's maintenance status and news, asks the user to keep, replace or remove each one with AskUserQuestion, then applies the decisions (keymaps rerouted, :Lazy clean, README), verifies with headless Neovim and commits. Use for "audit my Neovim plugins", "棚卸しして", "Neovim のプラグインを整理したい".
allowed-tools: Read, Edit, Write, Grep, Glob, AskUserQuestion, WebSearch, WebFetch, Bash(nvim:*), Bash(gh api:*), Bash(gh repo view:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git rm:*), Bash(git commit:*), Bash(git pull:*), Bash(git push:*), Bash(ls:*), Bash(grep:*), Bash(sed:*), Bash(cat:*)
---

Audit the Neovim plugins in this repository together with the user: build the facts for every plugin, let the user decide one by one, then apply and verify the decisions. Claude Code only (it relies on AskUserQuestion).

## Where things are

- Neovim config: `home/.config/nvim/` in this repo (`~/.config` links to `home/.config`)
  - Plugin specs: `lua/plugins/*.lua` (lazy.nvim, one file per area)
  - Lockfile: `lazy-lock.json`; plugin list with sections and counts: `lua/plugins/README.md`
  - Options, keymaps, autocmds: `lua/config/{options,keymaps,autocmds}.lua`
- Neovim itself, LSP servers and treesitter parsers come from Nix: `nix/home/tools/neovim.nix`. Never install servers or parsers from inside Neovim (no mason, no `:TSInstall`).
- The work Mac applies changes made here after pulling; see AGENTS.md.

## Step 1: Establish the baseline

1. Get the Neovim version (`nvim --version`) and read the bundled release notes: `$(dirname $(dirname $(readlink -f $(command -v nvim))))/share/nvim/runtime/doc/news*.txt`. List what the core now covers (commands, default keymaps, options, built-in plugins under `runtime/pack/dist/opt`).
2. Search the web for recent changes in the plugin ecosystem that affect this config: archived or rewritten plugins, deprecated setup styles, new de facto choices. Keep the source URLs.

## Step 2: Build the inventory

For every plugin in `lazy-lock.json` (and every spec in `lua/plugins/`, including disabled ones):

- Role, in one line, and the keymaps and commands this config gives it (grep the spec)
- Maintenance: last push and archived flag via `gh api repos/<owner>/<repo> --jq '{pushed_at, archived}'`
- What replaces it, if anything: a core feature (Step 1), another plugin already in the config (e.g. snacks.nvim), or a successor
- Recent news from the web when it matters (archival, breaking rewrite, deprecation)
- Dependents: other specs that list it in `dependencies` or call `require('<it>')`

Classify each as keep, replace, remove or ask. Judge by how the user works now: agents write most of the code, and Neovim is mainly for reading files and pointing Claude Code at them (claudecode.nvim), so reading and navigation matter more than writing aids. When the user wants to go conservatively, handle "replaced by core or a duplicate" first and leave writing aids for later.

Show the user a short summary (counts, the notable findings such as archived plugins or config that silently does nothing) before asking.

## Step 3: Ask plugin by plugin

Use AskUserQuestion, at most 4 questions per call, one plugin (or one tight group, e.g. a plugin and its only dependency) per question:

- The question says what the plugin does in this config, its keymaps, and the last update date (plus "archived" when true)
- Options are concrete actions, not yes/no: "Keep", "Remove", "Replace with <core feature or plugin>". Put the recommended one first with "(Recommended)"
- Each option's description gives the reason and what takes over (the core feature, the other plugin, or nothing), including news found on the web
- Do not ask about plugins whose fate is obvious and already agreed (e.g. disabled specs); list them as done instead

If the user rejects the question to clarify, stop and ask what they want to know before continuing.

## Step 4: Apply

For each removal or replacement:

- Delete the spec (or the block inside a shared file) and any `dependencies` entries pointing at it
- Reroute keymaps the user relies on to the replacement (usually in `lua/config/keymaps.lua`), keeping the same keys when possible
- Update `lua/plugins/README.md`: remove the entry, fix the section counts, and note replacements under "Replaced by Neovim itself"
- Run `nvim --headless '+Lazy! clean' +qa` so the plugin is removed and `lazy-lock.json` is updated
- If the change needs something outside Neovim (a server, a parser), add it to `nix/home/tools/neovim.nix`, build both hosts as AGENTS.md describes, and ask the user to run darwin-rebuild

## Step 5: Verify

With headless Neovim (`nvim --headless -c 'lua ...'`), check:

- No messages after startup (`vim.api.nvim_exec2('messages', { output = true })`) with a real file open
- Every rerouted keymap exists (`vim.fn.maparg(...)`) and does what it should (e.g. feed the keys and inspect the buffer)
- For LSP or treesitter changes: `vim.lsp.get_clients({ bufnr = buf })` and `vim.treesitter.highlighter.active[buf]` on a file of each affected language

Say plainly what could not be checked headless (rendering, popups) and ask the user to look.

## Step 6: Commit and report

- Other sessions work in this repo at the same time: `git pull --ff-only`, then `git status` and `git diff --cached`, and stage only the files this audit changed
- Commit in English: an imperative summary, then a short body with the reasons (see AGENTS.md; no session links or attribution trailers)
- Report: a table of decisions, keymaps that changed, what was verified and what the user should check by eye, and the steps for the work Mac (pull, `nvim --headless '+Lazy! restore' '+Lazy! clean' +qa`, and darwin-rebuild when Nix changed)
