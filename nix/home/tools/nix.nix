{ ... }:
{
  # extended_glob treats `#` in flake refs (nixpkgs#foo) as a glob pattern
  my.human.aliases.nix = "noglob nix";
}
