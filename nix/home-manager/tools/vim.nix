# vim: macOS's /usr/bin/vim, the fallback when Neovim is broken. Nix only
# lays the ground: the .vimrc link and vim-plug itself. The plugins are
# installed with :PlugInstall, as Neovim's are by lazy.nvim, and .vimrc
# works without them. Update vim-plug with flake.lock, not :PlugUpgrade,
# which cannot write into the store.
{ config, pkgs, ... }:
let
  # macOS's vim, by path: what this file sets up, not whichever vim is
  # first on PATH
  vim = "/usr/bin/vim";
in
{
  home.file = {
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.my.repo}/home/.vimrc";
    ".vim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/plug.vim";
  };

  # tovim: edit what a pipe passes through vim and send the result on
  # (`ls -l | tovim | cut -d: -f1`); a path piped in is just opened.
  # http://vim-jp.org/blog/2015/10/15/tovim-on-shell-command-pipes.html
  home.packages = [
    (pkgs.writeShellApplication {
      name = "tovim";
      text = ''
        trap 'rm -f "''${TOVIMTMP-}"' ERR

        if [ -p /dev/stdin ]; then
            in="$(cat <&0)"
            if [ -z "$in" ];then
                exit 0
            fi

            if [ -e "$in" ]; then
                ${vim} "$in" </dev/tty >/dev/tty
            else
                TOVIMTMP=~/.tovim_tmp_"$(date +%Y-%m-%d_%H-%M-%S.txt)"
                echo "$in" >"$TOVIMTMP"
                ${vim} "$TOVIMTMP" </dev/tty >/dev/tty
                cat "$TOVIMTMP"
                rm "$TOVIMTMP"
            fi
        else
            ${vim} "$@"
        fi
      '';
    })
  ];

  my.human.aliases.vi = "command vim";
  my.human.globalAliases.VI = "| xargs -o vim";
}
