# oh-my-mermaid (omm): a CLI that stores and views Mermaid architecture docs
# under .omm/, with Agent Skills that have the agent scan a codebase into it.
# Not in nixpkgs. The skills come from the same pinned source, so they match
# the CLI; `omm setup` would copy them into ~/.claude by hand instead.
#
# omm-push is left out: it uploads the docs to ohmymermaid.com, and they
# describe a codebase's internals, which must not leave the work Mac.
{ pkgs, ... }:
let
  omm = pkgs.buildNpmPackage (finalAttrs: {
    pname = "oh-my-mermaid";
    version = "0.2.0";

    src = pkgs.fetchFromGitHub {
      owner = "oh-my-mermaid";
      repo = "oh-my-mermaid";
      tag = "v${finalAttrs.version}";
      hash = "sha256-kMo8nmyuuaL16QwXxPcLHS3F64vSLfNCgXM31vUUgPo=";
    };

    npmDepsHash = "sha256-B6+dxmh4cdItS3QvTIkxt6/YAEnjVs1dIY86e/9uGEA=";
  });
in
{
  home.packages = [ omm ];

  # The skills run `command -v omm || npm install -g oh-my-mermaid` first;
  # with omm on PATH from here, the npm fallback never runs.
  my.skills = {
    omm-scan = "${omm.src}/skills/omm-scan";
    omm-view = "${omm.src}/skills/omm-view";
  };
}
