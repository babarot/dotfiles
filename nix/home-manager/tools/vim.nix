# vim: macOS's /usr/bin/vim, the fallback when Neovim is broken. Nix only
# lays the ground: the .vimrc link and vim-plug itself. The plugins are
# installed with :PlugInstall, as Neovim's are by lazy.nvim, and .vimrc
# works without them. Update vim-plug with flake.lock, not :PlugUpgrade,
# which cannot write into the store.
{ config, pkgs, ... }:
{
  home.file = {
    ".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.my.repo}/home/.vimrc";
    ".vim/autoload/plug.vim".source = "${pkgs.vimPlugins.vim-plug}/plug.vim";
  };

  my.human.aliases.vi = "command vim";
  my.human.globalAliases.VI = "| xargs -o vim";
}
