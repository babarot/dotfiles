# Docs

The docs are split by what the reader wants, following [Diátaxis](https://diataxis.fr/) cut down to three kinds:

| Folder | The reader wants to | Test |
|---|---|---|
| [guides/](./guides) | get something done, step by step | the title reads "How to ..." |
| [concepts/](./concepts) | understand how a part works and why | it explains, and has no steps to follow |
| [reference/](./reference) | look something up | it is consulted, not read through |

Rules for adding a page:

- Pick the folder with the test above. A page that needs two folders is two pages.
- One task per guide, so the file names read as a table of contents.
- Do not repeat what the code or its comments already say; link to the file instead. A copy has to be kept in sync and turns into a lie when it is not.
- Keep it one level deep. [AGENTS.md](../AGENTS.md) holds the rules every task needs; a table or procedure only one kind of task needs lives here, linked from AGENTS.md where that task starts.

## Guides

- [setup-mac.md](./guides/setup-mac.md): set up a new Mac
- [migrate-mac.md](./guides/migrate-mac.md): move a Mac set up by hand to this flake
- [install-from-git.md](./guides/install-from-git.md): install a zsh plugin or a script from a git repository or gist
- [gist-cli.md](./guides/gist-cli.md): decide whether a command of your own may live in a gist, and write, test and change one
- [maintenance.md](./guides/maintenance.md): update inputs, patch a package, add a Mac, retire a skill

## Concepts

- [dependencies.md](./concepts/dependencies.md): why deleting a tool's file removes all of it and breaks nothing else (cohesion, loose coupling, reproducibility)
- [workflow.md](./concepts/workflow.md): worktrees, herdr workspaces, review and landing
- [modules.md](./concepts/modules.md): the `my.*` options and how they reach the Mac
- [ai-agents.md](./concepts/ai-agents.md): how Claude Code, Codex and their skills are wired in

## Reference

- [where-things-go.md](./reference/where-things-go.md): where each kind of thing is declared (tools, sets, apps, settings, skills, patches)
- [decisions.md](./reference/decisions.md): what was tried or used and dropped, and why, so it is not brought back
- [herdr.md](./reference/herdr.md): what is set up for herdr: its keys for panes, tabs, spaces and copy mode, the commands that switch spaces, the patches on it and its companions
