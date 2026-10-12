# security-audit: Cloudflare's Agent Skill for multi-phase security audits
# of a codebase (MIT). The repo has no releases, so it is fetched at a fixed
# commit; read the diff before bumping rev.
#
# Its validators are run as `node <skill-dir>/validate-*.cjs`, a bare node
# from the agent's PATH (packages.nix's nodejs or mise). A skill is not a
# process, so it cannot be wrapped with a PATH; pointing it at a store node
# would mean rewriting its Markdown, a patch kept on every update.
{ pkgs, ... }:
let
  src = pkgs.fetchFromGitHub {
    owner = "cloudflare";
    repo = "security-audit-skill";
    rev = "c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
    hash = "sha256-oVVACjotkHvllQGxEP8yWaEt4c3GxT0d909TUM5P3NM=";
  };
in
{
  my.skills.security-audit = "${src}/skills/security-audit";
}
