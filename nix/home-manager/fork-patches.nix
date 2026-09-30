# my.forkPatches: packages built with patches exported from the patches
# branch of a fork (docs/guides/maintenance.md). A tool's .nix file
# declares its entry next to the package and applies `.patches` from it,
# so the patch directory is named once. .githooks/check-patches reads the
# same entries to check the files against the fork, so a new patched
# package needs no change there.
{ inputs, lib, ... }:
{
  options.my.forkPatches = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        {
          options = {
            src = lib.mkOption {
              type = lib.types.package;
              description = "The upstream source the patches apply to, fetched with fetchFromGitHub from its release tag.";
            };
            dir = lib.mkOption {
              type = lib.types.path;
              description = "The directory of the exported patch files, applied in name order.";
            };
            fork = lib.mkOption {
              type = lib.types.str;
              default = "babarot/${name}";
              description = "The GitHub fork whose patches branch the files are exported from.";
            };
            patches = lib.mkOption {
              type = lib.types.listOf lib.types.path;
              readOnly = true;
              default = lib.filter (lib.hasSuffix ".patch") (lib.filesystem.listFilesRecursive config.dir);
            };
            # For .githooks/check-patches
            check = lib.mkOption {
              type = lib.types.attrsOf lib.types.str;
              readOnly = true;
              default = {
                inherit (config) fork;
                upstream = "${config.src.owner}/${config.src.repo}";
                tag =
                  if config.src.tag or null != null then
                    config.src.tag
                  else
                    lib.removePrefix "refs/tags/" config.src.rev;
                dir = lib.removePrefix "${toString inputs.self}/" (toString config.dir);
              };
            };
          };
        }
      )
    );
  };
}
