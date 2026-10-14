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
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # gh-dash reads ~/.config/gh-dash/config.yml, then this file on top:
      # issuesSections with work projects, kept out of this public repo
      # (gitignored). gh-dash fails to start if the file is missing
      my.env.GH_DASH_CONFIG = "${config.home.homeDirectory}/.config/gh-dash/work.yml";

      # Claude Code instructions only for this Mac, read alongside the shared
      # ~/.claude/CLAUDE.md. Linked to the repo, like CLAUDE.md, so edits
      # apply without a switch
      home.file.".claude/rules/PC-M-2025-026.md".source =
        config.lib.file.mkOutOfStoreSymlink "${config.my.repo}/home/.claude/rules/PC-M-2025-026.md";

      my.agentSkills.scopes = [
        "core"
        "work"
      ];

      # GitHub Copilot CLI comes from the official installer
      # (~/.local/bin/copilot), not nixpkgs: it downloads its own updates,
      # which the read-only Nix store would hold back. Activation only installs
      # it when missing. Activation has a minimal PATH; with ~/.local/bin on
      # it the installer does not offer to add a PATH line to a shell rc.
      my.knownBins.".local/bin" = [ "copilot" ];
      home.activation.copilotCli = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [[ ! -e "$HOME/.local/bin/copilot" ]]; then
          run /usr/bin/env PATH="$HOME/.local/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
            /bin/bash -c 'curl -fsSL https://gh.io/copilot-install | bash' \
            || warnEcho "Copilot CLI: install failed; run: curl -fsSL https://gh.io/copilot-install | bash"
        fi
      '';

      home.packages = with pkgs; [
        ctop
        dart
        diff-so-fancy
        gcalcli
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
