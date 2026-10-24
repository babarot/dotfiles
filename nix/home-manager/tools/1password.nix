# 1Password (the app is a cask in nix/homebrew.nix): its SSH agent holds
# the key that signs commits and authenticates to GitHub, so the private
# key never sits in ~/.ssh. Each Mac has a key of its own, set in its host
# directory as my.gitSigningKey; a Mac without one does not sign commits.
# The agent itself is turned on in the app (Settings > Developer > Use the
# SSH agent), which Nix cannot reach.
{ config, lib, ... }:
let
  key = config.my.gitSigningKey;
  # The app's own paths; the cask installs it in /Applications
  opSshSign = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
  agentSock = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";
in
{
  options.my.gitSigningKey = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "Public key of this Mac's 1Password SSH key, e.g. \"ssh-ed25519 AAAA...\".";
  };

  config = lib.mkIf (key != null) {
    my.gitConfig = {
      user.signingkey = key;
      commit.gpgsign = "true";
      gpg.format = "ssh";
      "gpg.ssh" = {
        program = opSshSign;
        # Lets `git log --show-signature` verify this Mac's commits
        allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      };
    };

    xdg.configFile."git/allowed_signers".text = ''
      b4b4r07@gmail.com namespaces="git" ${key}
    '';

    # GitHub only: other hosts (the NAS) keep their own keys. Pulled in by
    # `Include config.d/*` at the top of the hand-written ~/.ssh/config.
    home.file.".ssh/config.d/1password".text = ''
      Host github.com ssh.github.com
        IdentityAgent "${agentSock}"
    '';
  };
}
