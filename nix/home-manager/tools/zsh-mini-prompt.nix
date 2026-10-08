{ inputs, ... }:
{
  my.human.plugins.zsh-mini-prompt = {
    src = inputs.zsh-mini-prompt;
    file = "zsh-mini-prompt.zsh-theme";
    preInit = ''
      zstyle ':prompt:mini:path' style 'minimal'
      zstyle ':prompt:mini:right' template '%exitcode% %F{242}%git%%f %path%'
      zstyle ':prompt:mini:left' template '%sign% '
      zstyle ':prompt:mini:sign' color-on-error true
      zstyle ':prompt:mini:sign' vimode-indicator true
      zstyle ':prompt:mini:vimode' enable true
      zstyle ':prompt:mini:git' format '(%s)'
      zstyle ':prompt:mini:git' show-dirty true
      zstyle ':prompt:mini:git' show-untracked true
      zstyle ':prompt:mini:git' show-stash true
      zstyle ':prompt:mini:git' show-upstream true
      zstyle ':prompt:mini:git' show-behind-base true
    '';
  };
}
