# Work Mac. Put settings that only this machine needs here.
# MDM-managed apps (Self Service, Microsoft Defender) are out of scope.
{ ... }:
{
  # Vendor apps only for this Mac (see nix/homebrew.nix)
  homebrew.casks = [
    "acreom"
    "claude"
    "cmux"
    "codex-app"
    "github-copilot-app"
    "inkdrop"
    "path-finder"
    "rectangle"
    "typora"
    "zoom"
  ];
  homebrew.brews = [
    "datadog-labs/pack/pup" # Datadog CLI; `pup` in nixpkgs is a different tool
  ];

  home-manager.users.babarot =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dart
        gcalcli
        github-copilot-cli
        google-cloud-sql-proxy
        helmfile
        kamal-proxy
        krew
        kustomize
        litecli
        mysql84
        nerd-fonts.monaspace
        (noto-fonts.override { variants = [ "NotoSansSymbols2" ]; })
      ];

      my.masApps = {
        "MeetingBar" = 1532419400;
        "Slack" = 803453959;
      };
    };
}
