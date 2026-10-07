# herdr

What is set up here for herdr beyond what it does out of the box: the keys in effect for panes, tabs and spaces (what herdr's sidebar shows; its API and docs call them workspaces), the commands that do the same from a shell, the patches on herdr itself, and the companions built around it. How they are used day to day is [workflow.md](../concepts/workflow.md).

## Keys

The prefix is `ctrl+s`; pressing it twice sends a literal `ctrl+s`. A key marked config.toml is set in [config.toml](../../home/.config/herdr/config.toml), which says why next to it; the rest are herdr's defaults. A key set there replaces herdr's default for that action, and a default whose key is taken there is dropped, so the old key may do nothing or something else (both listed under [Defaults taken over](#defaults-taken-over)). `prefix+?` shows every binding in effect, from herdr itself.

### Spaces

| Key | Does | From |
|---|---|---|
| `prefix+f` | Pick a space from a tree with fzf and switch to it ([herdr-space-switch](#herdr-space-switch)) | config.toml |
| `prefix+w` | herdr's own space navigator (`up`/`down` to move, `h/j/k/l` between panes) | herdr |
| `prefix+g` | herdr's goto picker | herdr |
| `prefix+a` | Go to the pane of the latest notification | config.toml |
| `prefix+shift+n` | New space | herdr |
| `prefix+shift+g` | New worktree, opened as a space | herdr |
| `prefix+shift+w` | Rename the space | herdr |
| `prefix+shift+d` | Close the space (a worktree's checkout stays; herdr-worktree-ctl removes it) | herdr |
| `prefix+b` | Show or hide the sidebar | herdr |

### Tabs

| Key | Does | From |
|---|---|---|
| `prefix+c` | New tab | herdr |
| `prefix+n`, `prefix+ctrl+l` | Next tab | config.toml |
| `prefix+p`, `prefix+ctrl+h` | Previous tab | config.toml |
| `prefix+1` ... `prefix+9` | Go to that tab | herdr |
| `prefix+shift+t` | Rename the tab | herdr |
| `prefix+shift+x` | Close the tab | herdr |

### Panes

| Key | Does | From |
|---|---|---|
| `prefix+h/j/k/l` | Go to the pane left, below, above, right | herdr |
| `prefix+o`, `ctrl+o` | Go to the other pane, or the next with three or more; `ctrl+o` needs no prefix and so never reaches the app in the pane | config.toml |
| `prefix+shift+tab` | Go to the previous pane in order | herdr |
| `prefix+;` | Go back to the last pane | config.toml |
| `prefix+v`, `prefix+\|` | Split side by side | config.toml |
| `prefix+-` | Split stacked | herdr |
| `prefix+x`, `prefix+q` | Close the pane | config.toml |
| `prefix+z` | Zoom the pane, or unzoom | herdr |
| `prefix+shift+h/j/k/l` | Resize one step left, down, up, right (no repeat; press the prefix again) | config.toml |
| `prefix+r` | Resize mode: `h/j/k/l` or the arrows, repeatedly, until `esc` or `enter` | herdr |
| `prefix+shift+p` | Rename the pane (a leading `*` or `!` marks a pane in use) | herdr |
| `prefix+e` | Open the pane's scrollback in `$EDITOR` | herdr |
| `prefix+[` | Copy mode ([below](#copy-mode)) | herdr |

### Copy mode

`prefix+[` enters it on the focused pane; the pane keeps running.

| Key | Does |
|---|---|
| `v`, `space` / `V` | Start a selection / a selection of whole lines |
| `o` | Go to the other end of the selection (a [patch](#patches) here) |
| `y`, `enter` | Copy the selection and leave |
| `q`, `esc` | Leave without copying (`esc` first clears a selection or a search) |
| `h/j/k/l`, `w/b/e`, `W/B/E` | Move by character, word, big word |
| `0`, `^`, `$` | Start of the line, first non-blank, last character |
| `{`, `}`, `g`, `G` | Previous and next paragraph, top and bottom of the history |
| `ctrl+u/d`, `ctrl+b/f` | Half a page, a page up and down |
| `/`, `?`, `n`, `N` | Search forward, backward, and repeat |

### Other

| Key | Does | From |
|---|---|---|
| `prefix+t` | A scratch shell in a popup, in the focused pane's directory | config.toml |
| `prefix+shift+v` | Show or hide the reviewr pane | config.toml |
| `prefix+shift+r`, `prefix+shift+s` | hunk: review the changes, send the review to the agent | config.toml |
| `prefix+shift+c`, `prefix+shift+a` | hunk: review the last commit, the staged changes | config.toml |
| `prefix+ctrl+r` | Reload config.toml | config.toml |
| `prefix+s` | herdr's settings | herdr |
| `prefix+d` | Detach | config.toml |
| `prefix+?` | Every binding in effect | herdr |

### Defaults taken over

herdr's defaults that config.toml gives to something else, for reading herdr's own docs:

| Key | herdr's default | Here |
|---|---|---|
| `prefix+o` | Latest notification | Next pane; the notification is `prefix+a` |
| `prefix+q` | Detach | Close the pane; detach is `prefix+d` |
| `prefix+shift+r` | Reload config | hunk review; reload is `prefix+ctrl+r` |
| `prefix+shift+h/j/k/l` | Swap the pane with its neighbor | Resize; swapping has no key |
| `prefix+tab` | Next pane | Nothing; the next pane is `prefix+o` |

## Commands

These talk to the running herdr, from any shell inside or outside it.

### herdr-space-switch

Built in [herdr/space-switch.nix](../../nix/home-manager/tools/herdr/space-switch.nix) from a gist; `prefix+f` runs it in a popup.

```bash
herdr-space-switch                     # pick from every space
herdr-space-switch dot                 # start with "dot" typed; one match switches at once
herdr-space-switch --git=status        # add each checkout's marks: * + $ % ↑ ↓
herdr-space-switch --git=branch,status # add the branch too, columns in this order
herdr-space-switch -g                  # the same as --git=status,branch
```

In the picker, `ctrl-/` shows the preview below, moves it to the right and hides it; `ctrl-d`/`ctrl-u` scroll it. The status mark is the one the API reports, which can differ from the sidebar's: the sidebar keeps what it has shown on its own.

### herdr itself

```bash
herdr workspace list                   # every space as JSON: id, label, number, state, worktree
herdr workspace focus <workspace_id>   # switch to a space
herdr tab list --workspace <id>        # its tabs
herdr pane list --workspace <id>       # its panes, with agent, state and title
herdr pane read <pane_id> --lines 50   # the end of a pane's output
herdr server reload-config             # what prefix+ctrl+r does
```

`herdr <command> --help` lists the rest (`tab`, `pane`, `agent`, `worktree`).

## Patches

herdr is nixpkgs' build with these patches, one per change, applied in name order. Each patch file's message says what it does and why; they are commits on the `patches` branch of the fork [babarot/herdr](https://github.com/babarot/herdr), exported here with the import-fork-patches skill, never edited here. Making and carrying one is [maintenance.md](../guides/maintenance.md#patch-a-package-from-a-fork-branch); the build is in [herdr.nix](../../nix/home-manager/tools/herdr.nix). When a patch is added, changed or dropped, change its row here.

| Patch | What changes |
|---|---|
| [0001](../../nix/home-manager/tools/herdr/0001-Keep-a-renamed-worktree-space-s-branch-in-the-sideba.patch) | A worktree space renamed after its feature still shows its branch and ahead/behind in the sidebar (herdrdev/herdr#2952) |
| [0002](../../nix/home-manager/tools/herdr/0002-Add-a-worktree-space-token.patch) | A `worktree` token for the sidebar's rows: the checkout's directory name, which other sessions go by |
| [0003](../../nix/home-manager/tools/herdr/0003-Add-a-name-field-to-the-new-worktree-dialog.patch) | The new worktree dialog (`prefix+shift+g`) takes the space's name, leaving the generated branch and checkout alone |
| [0004](../../nix/home-manager/tools/herdr/0004-Add-Mark-as-unread-to-a-space-s-menu.patch) | "Mark as unread" in a space's menu brings back the Done mark of its agents already looked at (herdrdev/herdr#4622) |
| [0005](../../nix/home-manager/tools/herdr/0005-Add-o-to-copy-mode-to-jump-to-the-other-end-of-the-s.patch) | `o` in copy mode goes to the other end of the selection, as in tmux and Vim |

## Companions

What exists only for herdr, built in [herdr.nix](../../nix/home-manager/tools/herdr.nix) or the files it imports from [herdr/](../../nix/home-manager/tools/herdr), so deleting herdr.nix removes them too. Each file's header says what it does.

| Companion | What it is |
|---|---|
| [herdr-space-switch](../../nix/home-manager/tools/herdr/space-switch.nix) | The space picker on `prefix+f` ([above](#herdr-space-switch)); the script is a gist |
| herdr-worktree-ctl ([herdr.nix](../../nix/home-manager/tools/herdr.nix)) | Lists herdr's worktrees and removes the ones picked, as closing a space leaves the checkout; the script is a gist |
| [worktree-layout](../../nix/home-manager/tools/herdr/worktree-layout.nix) | A plugin that lays out each new or opened worktree space: Claude Code, reviewr, a shell |
| [worktree-status](../../nix/home-manager/tools/herdr/worktree-status.nix) | A launchd agent that puts marks after a worktree space's name by conditions set per Mac |
| [reviewr](../../nix/home-manager/tools/herdr/reviewr.nix), [hunk-diff](../../nix/home-manager/tools/herdr/hunk-diff.nix) | Review plugins, on the keys under [Other](#other) |
| [plugins.nix](../../nix/home-manager/tools/herdr/plugins.nix) | `my.herdrPlugins`, which registers the plugins with herdr on every switch |
