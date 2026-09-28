# herdr-hunk-diff: herdr plugin that opens hunk on the focused agent's
# worktree and sends the review comments back to that agent.
# It runs the hunk it bundles (newer than nixpkgs' hunk), not pkgs.hunk.
{ pkgs, ... }:
let
  inherit (pkgs) nodejs;

  herdr-hunk-diff = pkgs.buildNpmPackage (finalAttrs: {
    pname = "herdr-hunk-diff";
    version = "0.4.0";

    src = pkgs.fetchFromGitHub {
      owner = "jhochenbaum";
      repo = "herdr-hunk-diff";
      tag = "v${finalAttrs.version}";
      hash = "sha256-dmkSzPvOSjy4gyD5c7LTIJbvyhSNSRAONVLubz9J94M=";
    };

    npmDepsHash = "sha256-x7XJ+cxwaHUOrhfjKxQ6vBDepy+84R9X1vTPjYesxsQ=";
    inherit nodejs;

    # The manifest calls a bare `node`, which would be mise's per-project one
    postPatch = ''
      substituteInPlace herdr-plugin.toml \
        --replace-fail '["node", ' '["${nodejs}/bin/node", ' \
        --replace-fail 'exec node ' 'exec ${nodejs}/bin/node '
    '';

    # The plugin root is $out; the bundled hunk is a compiled single binary
    # that breaks when stripped. npm unpacks it without the exec bit and
    # hunk.cjs chmods it on first run, which a read-only store path refuses.
    installPhase = ''
      runHook preInstall
      npm prune --omit=dev --no-audit --no-fund
      chmod +x node_modules/hunkdiff-*/bin/hunk
      mkdir -p $out
      cp -r herdr-plugin.toml dist node_modules package.json $out/
      runHook postInstall
    '';
    dontStrip = true;
  });
in
{
  my.herdrPlugins."jhochenbaum.hunkdiff" = herdr-hunk-diff;
}
