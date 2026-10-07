# Move a Mac set up by hand to this flake

On a Mac set up by hand (or with the old afx/Brewfile setup), a few things get in the way of the first switch in [setup-mac.md](./setup-mac.md#2-the-first-switch). Clear them before it, then follow that page as usual.

- Homebrew installed with the official script: nix-homebrew takes it over on the first switch (`autoMigrate`). It replaces the Homebrew repository in `/opt/homebrew` and keeps the installed formulae, casks and taps.
- Vendor apps installed without Homebrew: `brew bundle` refuses to overwrite them. Put them under Homebrew first with `brew install --cask --adopt <cask>`; when the installed version differs, use `brew install --cask --force <cask>` (settings stay in `~/Library`). If it fails with "Operation not permitted", give the terminal the App Management permission in System Settings > Privacy & Security.
- Symlinks left by afx (e.g. `~/.tmux/plugins/tpm`) and extensions installed with `gh extension install`: home-manager does not move them, so remove them before switching.
- An app that moves from `/Applications` to Nix: quit the old one before moving it to the Trash. A copy still running from the Trash keeps its profile locked (Spotify showed only a black window).
- Old Homebrew formulae: uninstall with `HOMEBREW_NO_AUTOREMOVE=1` and check `brew autoremove --dry-run` before removing dependencies. Formulae from untrusted taps do not show up in `brew leaves`, and `brew untap` fails for those taps; remove `$(brew --repository)/Library/Taps/<owner>/homebrew-<repo>` instead.
- mise installed by Homebrew: after mise comes from Nix, run `mise reshim --force` so the shims stop pointing at the removed binary.
- After the switch, restart Claude Code (and other agents) from a new terminal tab; they keep the PATH of the tab they were started from.
