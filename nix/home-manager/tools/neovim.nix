# Neovim, and what its config expects from outside: LSP servers (found on
# PATH by vim.lsp.enable), conform's formatters, and treesitter parsers
# with their queries. They come from here instead of mason and
# nvim-treesitter's :TSInstall, so the two Macs get the same versions,
# pinned by flake.lock.
{ lib, pkgs, ... }:
let
  # Neovim ships c, lua, markdown, markdown_inline, query, vim and vimdoc;
  # adding them here would shadow its own queries
  languages = [
    "astro"
    "bash"
    "css"
    "dockerfile"
    "git_config"
    "git_rebase"
    "gitignore"
    "go"
    "gomod"
    "gosum"
    "hcl"
    "html"
    "ini"
    "javascript"
    "json"
    "just"
    "make"
    "nginx"
    "python"
    "requirements"
    "sql"
    "ssh_config"
    "terraform"
    "toml"
    "tsv"
    "tsx"
    "typescript"
    "xml"
    "yaml"
  ];
  # Queries other languages inherit (e.g. typescript's `; inherits: ecma`),
  # with no parser of their own
  sharedQueries = [
    "ecma"
    "html_tags"
    "jsx"
  ];
  ts = pkgs.vimPlugins.nvim-treesitter;
  treesitter = pkgs.symlinkJoin {
    name = "nvim-treesitter-site";
    paths =
      lib.concatMap (lang: [
        ts.grammarPlugins.${lang} # parser/<lang>.so
        ts.queries.${lang} # queries/<lang>/*.scm
      ]) languages
      ++ map (lang: ts.queries.${lang}) sharedQueries;
  };
  # Tools only Neovim runs: LSP servers and conform's formatters. They go
  # on nvim's own PATH, not the user's, so deleting jq.nix or go.nix does
  # not break formatting in nvim. Appended, so a version a project pins
  # with mise still wins.
  tools = with pkgs; [
    gopls
    lua-language-server
    terraform-ls
    go # gofmt
    gotools # goimports
    jq
    shfmt
    terraform
  ];
  neovim = pkgs.symlinkJoin {
    name = "neovim-with-tools";
    paths = [ pkgs.neovim ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/nvim --suffix PATH : ${lib.makeBinPath tools}
    '';
  };
in
{
  home.packages = [ neovim ];

  # lazy.nvim keeps stdpath('data')/site on the runtimepath
  home.file.".local/share/nvim/site/parser".source = "${treesitter}/parser";
  home.file.".local/share/nvim/site/queries".source = "${treesitter}/queries";

  my.human.aliases = {
    vim = "nvim";
    # Neovim with no config, plugins or shada
    suvim = "nvim -u NONE -i NONE";
  };
}
