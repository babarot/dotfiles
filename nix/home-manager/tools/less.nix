# less is macOS's own; only its settings for humans live here.
# AI agents get PAGER=cat from .zshenv.
{ ... }:
{
  my.human.env = {
    LESS = "-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\\%..]";
    LESSCHARSET = "utf-8";
  };

  my.human.globalAliases.L = "| less";

  # Man page colors. $'...' is needed for the escape sequences, which
  # my.human.env would quote literally.
  my.human.init = ''
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[00;44;37m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
  '';
}
