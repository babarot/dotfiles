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

    # zsh plugins not in nixpkgs, sourced as-is
    enhancd = {
      url = "github:babarot/enhancd";
      flake = false;
    };
    za-prompt = {
      url = "github:babarot/za-prompt";
      flake = false;
    };
  };

  outputs =
    inputs@{ nix-darwin, home-manager, ... }:
    let
      mkHost =
        host:
        nix-darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./nix/darwin.nix
            host
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.users.babarot = import ./nix/home;
            }
          ];
        };
    in
    {
      # darwin-rebuild picks the entry matching `scutil --get LocalHostName`
      darwinConfigurations = {
        "pro23" = mkHost ./nix/hosts/pro23.nix;
        "PC-M-2025-026" = mkHost ./nix/hosts/PC-M-2025-026.nix;
      };
    };
}
