# tmux itself is not installed (not in use); tpm and .tmux.conf are kept
# for reference
{ inputs, ... }:
{
  # tpm installs the other plugins next to itself at runtime
  home.file.".tmux/plugins/tpm".source = inputs.tpm;
}
