{ pkgs, ... }:
{
  home.packages = [ pkgs.pinact ];

  # Supply-chain cooldown: skip releases younger than 7 days
  # (see also home/.config/uv/uv.toml)
  my.env.PINACT_MIN_AGE = "7";
}
