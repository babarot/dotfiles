{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # The filter and its preview, by store path: enhancd does not depend on
  # fzf.nix or eza.nix putting them on PATH
  fzf = lib.getExe pkgs.fzf;
  eza = lib.getExe pkgs.eza;
  fd = lib.getExe pkgs.fd;
  ghq = lib.getExe pkgs.ghq;

  # One LTSV line of enhancd's option menu (label:value, tab-separated)
  option = fields: lib.concatMapStringsSep "\t" (f: "${f.name}:${f.value}") fields;
  label = name: value: { inherit name value; };
in
{
  my.human.plugins.enhancd = {
    src = inputs.enhancd;
    file = "init.sh";
    order = 400;
  };

  my.human.env.ENHANCD_FILTER = lib.concatStringsSep " " [
    "${fzf} --preview '${eza} -al --tree --level 1 --group-directories-first --git-ignore"
    "--header --git --no-user --no-time --no-filesize --no-permissions {}'"
    "--preview-window right,50% --height 35% --reverse --ansi"
  ];

  # Options that run other tools, by store path. enhancd reads
  # ~/.enhancd/config.ltsv (ENHANCD_DIR) along with the hand-written
  # ~/.config/enhancd/config.ltsv, which keeps the rest
  home.file.".enhancd/config.ltsv".text = lib.concatLines [
    (option [
      (label "short" "-G")
      (label "long" "--ghq")
      (label "desc" "Show ghq path")
      (label "func" "${ghq} list --full-path")
      (label "condition" "")
    ])
    (option [
      (label "short" "-g")
      (label "long" "--git")
      (label "desc" "Show dirs managed by Git")
      (label "func" ''git rev-parse --show-toplevel; ${fd} --type directory --hidden --exclude .git --absolute-path . "$(git rev-parse --show-toplevel)" | sort'')
      (label "condition" "git rev-parse --is-inside-work-tree")
    ])
  ];
}
