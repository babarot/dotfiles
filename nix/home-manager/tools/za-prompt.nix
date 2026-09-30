{ inputs, ... }:
{
  my.human.plugins.za-prompt = {
    src = inputs.za-prompt;
    file = "za-prompt.zsh-theme";
    order = 300;
    preInit = ''
      zstyle ':prompt:za:path' style 'minimal'
      zstyle ':prompt:za:right' template '%exitcode% %path%'
      zstyle ':prompt:za:left' template '%sign% '
      zstyle ':prompt:za:sign' color-on-error true
      zstyle ':prompt:za:git' format '(%s)'
      zstyle ':prompt:za:git' show-dirty true
      zstyle ':prompt:za:git' show-untracked true
      zstyle ':prompt:za:git' show-stash true
      zstyle ':prompt:za:git' show-upstream true
    '';
  };
}
