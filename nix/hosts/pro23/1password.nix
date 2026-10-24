# This Mac's 1Password SSH key, which signs commits and authenticates to
# GitHub (1password.nix). Registered on GitHub as both an authentication
# and a signing key.
#
# my.gitSigningKey comes from 1password.nix; optionalAttrs keeps this Mac
# building without it (see herdr-devstack.nix).
{ lib, options, ... }:
{
  config = lib.optionalAttrs (options.my ? gitSigningKey) {
    my.gitSigningKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4c3rfK5T5ylIx/WU/fXHIDv0nJv3WLSNn7RDFA2v2C";
  };
}
