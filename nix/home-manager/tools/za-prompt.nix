{ inputs, ... }:
{
  my.human.plugins.za-prompt = {
    src = inputs.za-prompt;
    file = "za-prompt.zsh-theme";
    # Defines zle-line-init (its vi mode sign) for fast-syntax-highlighting
    # to wrap; loaded after it, it would replace the wrapper
    before = [ "fast-syntax-highlighting" ];
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
