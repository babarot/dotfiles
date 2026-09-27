{ inputs, ... }:
{
  # tpm installs the other plugins next to itself at runtime
  home.file.".tmux/plugins/tpm".source = inputs.tpm;
}
