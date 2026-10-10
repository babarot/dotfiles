# Obsidian (the app is a cask in nix/homebrew.nix): my own skills that work
# on the vault. They live in the vault itself, in _skills/, where Obsidian
# Sync carries them to both Macs (it skips dot-folders such as .claude).
# The vault is outside this repo and private, so Nix cannot read it; the
# links are made at activation instead, which keeps the skill names out of
# this public repo. Adding or removing a skill needs a switch; editing one
# does not, since the links point into the vault.
{ config, lib, ... }:
let
  vault = "${config.home.homeDirectory}/Obsidian/vault";
in
{
  home.activation.vaultSkills = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    src=${lib.escapeShellArg "${vault}/_skills"}
    for dest in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
      run mkdir -p "$dest"
      # Drop links to skills that are no longer in the vault
      for link in "$dest"/*; do
        [ -L "$link" ] || continue
        case "$(readlink "$link")" in
          "$src"/*) [ -e "$link" ] || run rm "$link" ;;
        esac
      done
      [ -d "$src" ] || continue
      for dir in "$src"/*/; do
        [ -f "$dir/SKILL.md" ] || continue
        dir=''${dir%/}
        link="$dest/$(basename "$dir")"
        # Leave alone a name home-manager or anything else already uses
        if [ -e "$link" ] || [ -L "$link" ]; then
          [ "$(readlink "$link")" = "$dir" ] || continue
        fi
        run ln -sfn "$dir" "$link"
      done
    done
  '';
}
