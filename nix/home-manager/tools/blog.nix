{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.babarot.packages.${pkgs.stdenv.hostPlatform.system}.blog
    pkgs.hugo
  ];

  # Settings are in home/.config/blog/config.yaml
}
