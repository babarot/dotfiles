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
  # Tools Neovim runs by name: LSP servers, conform's formatters and what
  # snacks.nvim's pickers call. They go on nvim's own PATH, not the user's,
  # so deleting jq.nix, fd.nix or the ripgrep line in packages.nix does not
  # break nvim. Appended, so a version a project pins with mise still wins.
  tools = with pkgs; [
    gopls
    lua-language-server
    terraform-ls
    go # gofmt
    gotools # goimports
    jq
    shfmt
    terraform
    # snacks.nvim: files (fd, else a find that ignores .gitignore), grep (rg)
    # and its gh integration
    fd
    ripgrep
    gh
    # go.nvim: GoAddTag/GoRmTag, GoIfErr, GoAddTest, GoImpl (GoFillStruct
    # is a gopls code action). Copies in ~/go/bin (GOBIN, on the user's
    # PATH) come first, so keep these out of it
    gomodifytags
    iferr
    gotests
    impl
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

  # What go.nvim may go install on first use (url in its lua/go/install.lua),
  # less the ones in tools above
  my.knownBins."go/bin" = [
    "callgraph"
    "dlv"
    "fillswitch"
    "ginkgo"
    "go-enum"
    "gofumpt"
    "gojsonstruct"
    "golangci-lint"
    "gomvp"
    "gonew"
    "gotestsum"
    "govulncheck"
    "json-to-struct"
    "mockgen"
    "richgo"
  ];

  # lazy.nvim keeps stdpath('data')/site on the runtimepath
  home.file.".local/share/nvim/site/parser".source = "${treesitter}/parser";
  home.file.".local/share/nvim/site/queries".source = "${treesitter}/queries";

  my.human.aliases = {
    vim = "nvim";
    # Neovim with no config, plugins or shada
    suvim = "nvim -u NONE -i NONE";
  };
}
