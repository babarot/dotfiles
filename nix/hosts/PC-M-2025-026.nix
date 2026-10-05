# Work Mac. Put settings that only this machine needs here.
# MDM-managed apps (Self Service, Microsoft Defender) are out of scope.
{ user, ... }:
{
  # Vendor apps only for this Mac (see nix/homebrew.nix)
  homebrew.casks = [
    "acreom"
    "claude"
    "codex-app"
    "docker-desktop" # the private Mac uses OrbStack
    "github-copilot-app"
    "inkdrop"
    "path-finder"
    "popclip" # the private Mac has the App Store versions of these two
    "rectangle"
    "the-unarchiver"
    "typora"
    "zoom"
  ];
  homebrew.brews = [
    "datadog-labs/pack/pup" # Datadog CLI; `pup` in nixpkgs is a different tool
  ];

  home-manager.users.${user} =
    { config, pkgs, ... }:
    {
      # gh-dash reads ~/.config/gh-dash/config.yml, then this file on top:
      # issuesSections with work projects, kept out of this public repo
      # (gitignored). gh-dash fails to start if the file is missing
      my.env.GH_DASH_CONFIG = "${config.home.homeDirectory}/.config/gh-dash/work.yml";

      my.agentSkills.scopes = [
        "core"
        "work"
      ];

      home.packages = with pkgs; [
        ctop
        dart
        diff-so-fancy
        gcalcli
        github-copilot-cli
        golangci-lint
        google-cloud-sql-proxy
        goreleaser
        hub
        kamal-proxy
        litecli
        luarocks
        mysql84
        nerd-fonts.monaspace
        (noto-fonts.override { variants = [ "NotoSansSymbols2" ]; })

        # GNU sed only as gsed so BSD sed stays `sed`
        (runCommand "gsed" { } ''
          mkdir -p $out/bin
          ln -s ${gnused}/bin/sed $out/bin/gsed
        '')
      ];

      my.masApps = {
        "MeetingBar" = 1532419400;
        "Slack" = 803453959;
      };
    };
}
