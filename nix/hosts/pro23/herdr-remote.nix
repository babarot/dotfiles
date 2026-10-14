# herdr-remote on this Mac only: its agents, reached from a phone through
# Cloudflare (see nix/home-manager/tools/herdr/remote.nix).
#
# Guarded like herdr-devstack.nix, so deleting herdr.nix breaks nothing here.
{ lib, options, ... }:
{
  config = lib.optionalAttrs (options.my ? herdrRemote) {
    my.herdrRemote = {
      enable = true;
      tunnel = true;
      relayHost = "relay.babarot.dev";
      webHost = "herdr.babarot.dev";
    };
  };
}
