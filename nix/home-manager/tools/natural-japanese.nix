# natural-japanese: an Agent Skill for writing and revising Japanese prose
# for work (MIT), with linters that flag AI-sounding phrasing. Kept next to
# japanese-tech-writing.nix on purpose, to compare the two in use; they
# cover much of the same ground, so drop one once that is settled.
#
# SKILL.md runs its scripts with `uv run` (uv from packages.nix), and their
# PEP 723 headers make uv fetch sudachipy and sudachidict-core from PyPI
# into ~/.cache/uv on first use: a cache, not an install, and held back by
# exclude-newer in home/.config/uv/uv.toml. Having Nix provide them instead
# would mean rewriting the skill's Markdown, a patch kept on every update.
{ pkgs, ... }:
let
  version = "1.5.0";
  src = pkgs.fetchFromGitHub {
    owner = "coji";
    repo = "natural-japanese";
    tag = "v${version}";
    hash = "sha256-2haz6fzdiUlUkzzmyxIEzIAFCig3we54sb01RX5zD0c=";
  };
in
{
  my.skills.natural-japanese = "${src}/skills/natural-japanese";
}
