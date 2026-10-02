# Hand-written dotfiles in home/ of this repo, linked into ~. The links
# point at the repo, not the Nix store, so edits apply without a switch.
{ config, lib, ... }:
let
  repo = "${config.home.homeDirectory}/src/github.com/babarot/dotfiles";
  link = name: { source = config.lib.file.mkOutOfStoreSymlink "${repo}/home/${name}"; };
in
{
  home.file = lib.genAttrs [
    ".bashrc"
    ".curlrc"
    ".gitconfig"
    ".gitignore" # git's core.excludesfile
    ".gitmessage" # git's commit.template
    ".vimrc"
    ".zsh"
    ".zshenv"
    ".zshrc"
    "bin"
  ] link;

  # ~/.config links to the repo as a whole, so tools keep writing their
  # config here. It cannot be a home.file entry: home-manager writes files
  # inside it (zsh/env.zsh, zsh/human.zsh, ...), which then land in the
  # repo, ignored by home/.config/.gitignore. Linked before home-manager checks
  # its targets, so those files go through the link.
  home.activation.dotfilesConfigLink = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [[ -L ~/.config && "$(/usr/bin/readlink ~/.config)" == "${repo}/home/.config" ]]; then
      :
    elif [[ ! -e ~/.config && ! -L ~/.config ]]; then
      run /bin/ln -s "${repo}/home/.config" ~/.config
    else
      errorEcho "~/.config exists and is not a link to ${repo}/home/.config; move it aside and switch again"
      exit 1
    fi
  '';
}
