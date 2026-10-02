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

    # zsh plugins not in nixpkgs, sourced as-is
    enhancd = {
      url = "github:babarot/enhancd";
      flake = false;
    };
    za-prompt = {
      url = "github:babarot/za-prompt";
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

      mkHost =
        host:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./nix/darwin.nix
            ./nix/macos.nix
            nix-homebrew.darwinModules.nix-homebrew
            ./nix/homebrew.nix
            host
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              # Move files in the way (e.g. old afx links) aside instead of failing
              home-manager.backupFileExtension = "before-hm";
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.babarot = import ./nix/home-manager;
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
        "pro23" = mkHost ./nix/hosts/pro23.nix;
        "PC-M-2025-026" = mkHost ./nix/hosts/PC-M-2025-026.nix;
      };
    };
}
