{
  description = "babarot's macOS environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Installs Homebrew itself; pins the brew version it ships
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # babarot's own tools, published by GoReleaser on each release
    babarot = {
      url = "github:babarot/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # babarot's Agent Skills, linked into ~/.agents/skills
    agent-skills = {
      url = "git+ssh://git@github.com/babarot/agent-skills";
      flake = false;
    };

    # Tools not in nixpkgs that ship their own flake. Pinned to a release
    # tag; bump the tag to update.
    crit = {
      url = "github:tomasz-tomczyk/crit/v0.20.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code mods (plugins of hooks modules), loaded as-is
    claude-image-view = {
      url = "github:jarrodwatts/claude-image-view";
      flake = false;
    };
    # Mine, released with tagpr; bump the tag to update
    claude-linkify = {
      url = "github:babarot/claude-linkify/v0.2.0";
      flake = false;
    };

    # zsh plugins not in nixpkgs, sourced as-is
    enhancd = {
      url = "github:babarot/enhancd";
      flake = false;
    };
    zsh-mini-prompt = {
      url = "github:babarot/zsh-mini-prompt";
      flake = false;
    };

    # Scripts of my own kept in gists, out of this repo's history; each is
    # its own input, so updating one moves no other
    deadlink = {
      url = "git+https://gist.github.com/babarot/5a253e61a992d99a5a5834d092dd25cd.git";
      flake = false;
    };
    gist-ctl = {
      url = "git+https://gist.github.com/babarot/0bf79c7778a99d6ac5298ae61ab4b953.git";
      flake = false;
    };
    herdr-space-switch = {
      url = "git+https://gist.github.com/babarot/ce7ad05036abd1fcf3a56595757b62e0.git";
      flake = false;
    };
    herdr-worktree-ctl = {
      url = "git+https://gist.github.com/babarot/d7b198c8e7f26189e46f80e46053ff29.git";
      flake = false;
    };
    repo-cleanup = {
      url = "git+https://gist.github.com/babarot/c2c3436e248b21ee3c542dc3b8ead46a.git";
      flake = false;
    };

    # Formatters and linters behind `nix fmt` (see nix/treefmt.nix)
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";
      treefmt = treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./nix/treefmt.nix;

      # nix/hosts/<host>.nix is the Mac's darwin module; every *.nix directly
      # in nix/hosts/<host>/ is a home-manager module only that Mac imports,
      # as nix/home-manager/tools/ is for both
      # user is the macOS account on that Mac; the home directory and
      # everything under it follow from it
      mkHost =
        {
          host,
          user ? "babarot",
        }:
        let
          dir = ./nix/hosts + "/${host}";
          hostTools = nixpkgs.lib.optionals (builtins.pathExists dir) (
            map (f: dir + "/${f}") (
              builtins.filter (f: builtins.match ".*\\.nix" f != null) (builtins.attrNames (builtins.readDir dir))
            )
          );
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs user; };
          modules = [
            ./nix/darwin.nix
            ./nix/macos.nix
            nix-homebrew.darwinModules.nix-homebrew
            ./nix/homebrew.nix
            (./nix/hosts + "/${host}.nix")
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Move files in the way (e.g. old afx links) aside instead of failing
              home-manager.backupFileExtension = "before-hm";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.${user}.imports = [ ./nix/home-manager ] ++ hostTools;
            }
          ];
        };
    in
    {
      formatter.${system} = treefmt.config.build.wrapper;
      # `nix flake check` fails when a tracked file is not formatted
      checks.${system}.formatting = treefmt.config.build.check inputs.self;

      # darwin-rebuild picks the entry matching `scutil --get LocalHostName`
      darwinConfigurations = {
        "pro23" = mkHost { host = "pro23"; };
        "PC-M-2025-026" = mkHost { host = "PC-M-2025-026"; };
      };
    };
}
