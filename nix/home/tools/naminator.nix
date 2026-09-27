# The binary itself is still installed outside Nix (~/bin, go install)
# until it is published to the personal NUR repo
{ ... }:
{
  my.human.aliases.naminator = "naminator --group-by-date --group-by-ext --clean";
}
