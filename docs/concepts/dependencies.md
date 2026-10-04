# Dependencies

This repo is built so that what deleting a tool's file does can be told from that file alone. Three properties make that true:

- Cohesion: deleting a tool's file removes everything that was for the tool.
- Loose coupling: deleting a tool's file breaks nothing else.
- Reproducibility: a new Mac gets the same thing.

The rules that keep them are in [AGENTS.md](../../AGENTS.md#principles). This page explains why they work: what Nix gives that a PATH lookup could not, and why the rules take the shape they do.

## What came before

Tools have always depended on each other here. fzf is used by bat-theme, gcloud's configuration switcher, enhancd's `cd` and fzf-tab; fd is used by fzf, enhancd and Neovim's file picker.

Every earlier setup held those dependencies as a name on PATH. The `.zshrc` checked `(( $+commands[fzf] ))` before using fzf; zplug's `if:` and afx's `if:` did the same, and their `on:` and `depends-on` only ordered what was sourced. A name on PATH says nothing about who installed the command or which version it is. Delete it and whatever used it breaks silently, found only when it is next used; forget it on a new Mac and the same happens. Deleting kubectl left the `k` alias behind.

## Names on PATH, paths in the store

Nix builds every package into `/nix/store/<hash>-<name>-<version>`. The hash is computed from everything the build used (sources, dependencies, build steps), so a change to any of them gives a different path, and a path's contents never change. Two builds of fzf 0.74.4 that differ only in the tzdata they reference are two paths.

A package refers to what it needs by store path, not by name. nixpkgs' `bat` is a small script that puts less's store path at the front of PATH before running the real bat, so bat finds that less whatever the user's PATH holds. Nix scans each output for store paths it contains and records them as references; a package and everything it references, to the end, is its closure. Garbage collection removes only paths nothing references, so a dependency held by store path cannot disappear under the thing that uses it.

Commands are still typed by name. home-manager builds a profile, `/etc/profiles/per-user/$USER/bin`, with a link to each installed package's commands, and that one directory is on PATH. A switch rebuilds the profile: a new package adds links, a removed one loses them, and the store is left as it is.

## Settings are store paths too

home-manager writes generated files (`~/.config/zsh/human.zsh`, `~/.config/git/tools.gitconfig`, generated configs) into the store and links them into `~`. A generated file can therefore reference other store paths like a package does. In a `.nix` file, `lib.getExe pkgs.fzf` is fzf's store path as a string; embedding it in a generated file makes Nix record that the file references fzf.

[bat.nix](../../nix/home-manager/tools/bat.nix) defines `bat-theme` with `${fzf}` from `lib.getExe pkgs.fzf`, and the rendered `human.zsh` calls `/nix/store/…-fzf-0.74.4/bin/fzf` directly, without looking at PATH.

| | Name on PATH | Store path |
|---|---|---|
| Is the command there? | only a `$+commands` check can tell | always, while something references it |
| Which one runs? | the first on PATH | the one the path names |
| Its file is deleted | the user breaks silently | the user keeps working |
| A new Mac | whatever was remembered to be installed | the same paths, from `flake.lock` |

## Why a store path, and not the two simpler choices

Two simpler ways to let bat-theme use fzf each break one property:

1. Call `fzf` by name and leave installing it to `fzf.nix`. Deleting `fzf.nix` breaks bat-theme, and the build still passes. Loose coupling is lost.
2. Add fzf to `bat.nix`'s `home.packages` too. bat-theme keeps working, but deleting `fzf.nix` leaves `fzf` on PATH, installed by bat.nix. Cohesion is lost.

A store path keeps both: putting fzf on PATH stays `fzf.nix`'s job, and bat does not care whether it is there. However many files reference `pkgs.fzf`, it is one store path and one fzf; what matters is which file is responsible for putting it on PATH.

Deleting `fzf.nix` and building shows the result. The profile's `bin/fzf` link and everything in `fzf.nix` (its options, the `pskill` function) are gone. bat-theme, enhancd's filter, fzf-tab and `gchange` still run the fzf in the store, which stays because their generated files reference it.

## Three ways to hold a dependency

The way depends on where the other tool is run.

- Embed the path, for settings Nix renders: a function or variable in `human.zsh`, a plugin's `zstyle` (fzf-tab's `fzf-command`), a generated config ([enhancd.nix](../../nix/home-manager/tools/enhancd.nix) writes its filter and `config.ltsv` with fzf, eza, fd and ghq by path), a git setting ([ov.nix](../../nix/home-manager/tools/ov.nix)).
- Make a command, for a function that does not change the shell. `pkgs.writeShellApplication` builds a script whose first lines put the store paths of its `runtimeInputs` on PATH, as nixpkgs' bat does for less, so the script writes `fzf` by name and still gets the one it declared. It also runs shellcheck at build time. A function that runs `cd` or `export` cannot be one, since a command runs in its own process. `gchange` in [gcloud.nix](../../nix/home-manager/tools/gcloud.nix) is one.
- Wrap the program, for a program that runs many commands by name. Neovim's LSP setup, conform and snacks.nvim's pickers look up gopls, jq, fd and rg on PATH from hand-written Lua. [neovim.nix](../../nix/home-manager/tools/neovim.nix) wraps nvim with `wrapProgram --suffix PATH`, the mechanism nixpkgs' bat uses, so those commands are on nvim's PATH only. Deleting `jq.nix` or the ripgrep line leaves nvim working, LSP servers stay off the user's PATH, and a version a project pins with mise comes first.

## What stays a name

Some uses stay names, each for a reason:

- macOS's userland (awk, sed, ...) and git come with macOS, outside anything this repo adds or removes, so nothing here can take them away.
- Optional uses work either way. rm.nvim uses gomi when `executable('gomi')` and deletes normally otherwise.
- Hand-written configs cannot hold store paths. Configs you keep editing (keybinds, colors) are linked from the repo, not generated, so an edit applies at once instead of after a switch. A tool named in one is put on PATH by the file that owns the config, which keeps cohesion only when the tool is a companion: gh-dash's config runs delta and lazygit, which exist only for it, so `gh.nix` installs them and deleting it removes all three. A tool that is not a companion would stay installed after its own file is deleted, so such a config is generated with store paths instead when it rarely changes: gomi's preview and enter's ls module run eza from [gomi.nix](../../nix/home-manager/tools/gomi.nix) and [enter.nix](../../nix/home-manager/tools/enter.nix).

## Extra commands on PATH

Putting a package on PATH puts all of its commands there, and some packages bring names nobody asked for. `pkgs.gawk` also installs `bin/awk`, which came before macOS's BSD awk and changed what the BSD syntax agents write does. `pkgs.gotools` installs about fifty commands, and its `bundle` hid Ruby's. `pkgs.bashInteractive` installs `bin/sh`, which came before `/bin/sh`. Each is now a small package linking only the wanted command ([gawk.nix](../../nix/home-manager/tools/gawk.nix), [go.nix](../../nix/home-manager/tools/go.nix), [bash.nix](../../nix/home-manager/tools/bash.nix)). Such clashes stay unnoticed until something goes wrong, and agents, which write BSD syntax on purpose, hit them first.

## Reproducibility, and what Nix cannot hold

`flake.lock` pins nixpkgs and every other input, so both Macs build the same store paths. Some things cannot come from Nix: apps that update themselves or need `/Applications` (Homebrew casks), App Store apps (mas), Claude Code (its official installer), tools go.nvim installs with `go install`, and links a plugin makes at run time. Reproducibility does not require all of it to be Nix; it requires all of it to be declared, each in the file of what it is for, with its reason.

What is installed without a declaration is caught. Each switch uninstalls Homebrew casks and brews no file declares, so a cask tried by hand is gone at the next switch, as one deleted from a host file is. Commands that `curl | sh` installers and `npm install -g` put in `~/.local/bin`, and `go install` in `~/go/bin`, cannot be uninstalled that way, since there is no way to declare them short of packaging them; each switch names the ones no `my.knownBins` lists ([modules.md](./modules.md#myknownbins)).

## Load order

One kind of dependency Nix does not resolve: the order zsh plugins are sourced in. fzf-tab must load after compinit and before plugins that wrap widgets; zsh-abbr after the `bindkey -v` in `~/.zsh`. Each plugin names the plugins it loads after or before, and home-manager sorts them as a graph. Writing the order is what zplug's `on:` and afx's `depends-on` did; what changed is that each source line is a store path, so the plugin loaded is the one Nix built, and a name that is no longer a plugin is ignored, so deleting a plugin's file breaks no one.
