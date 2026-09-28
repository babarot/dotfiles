# tmux itself is not installed (not in use); tpm and .tmux.conf are kept
# for reference
{ config, inputs, ... }:
let
  repo = "${config.home.homeDirectory}/src/github.com/babarot/dotfiles";
  link = name: config.lib.file.mkOutOfStoreSymlink "${repo}/home/${name}";
in
{
  home.file = {
    ".tmux.conf".source = link ".tmux.conf";
    # Not ~/.tmux as a whole: tpm is placed inside it, so ~/.tmux is a
    # directory holding these two
    ".tmux/bin".source = link ".tmux/bin";
    # tpm installs the other plugins next to itself at runtime
    ".tmux/plugins/tpm".source = inputs.tpm;
  };
}
