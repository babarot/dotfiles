# ssh is macOS's own. ~/.ssh/config stays hand-written (programs.ssh would
# take over the whole file); only the hosts below are declared here, as
# files in ~/.ssh/config.d that the hand-written config pulls in with
# `Include config.d/*` before its first Host line. Hosts reached from this
# Mac only; the work Mac declares its own in its host directory.
{ ... }:
{
  # The Synology NAS on the home network. Its IP comes from DHCP and may
  # change, so it is reached by its mDNS name.
  home.file.".ssh/config.d/nas".text = ''
    Host nas
      HostName citadel.local
      User babarot
      IdentityFile ~/.ssh/nas
  '';
}
