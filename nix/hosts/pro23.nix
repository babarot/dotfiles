# Private Mac. Put settings that only this machine needs here.
{ user, ... }:
{
  # Vendor apps only for this Mac (see nix/homebrew.nix)
  homebrew.casks = [
    "autodesk-fusion"
    "bambu-studio"
    "discord"
    "google-drive"
    "logi-options+"
    "orbstack" # Docker and Linux VMs; the work Mac has Docker Desktop
    "parallels"
    "postman"
    "tabularis" # SQL client; updates itself
  ];

  home-manager.users.${user} =
    { config, pkgs, ... }:
    {
      home.packages = [ pkgs.agent-browser ];

      # OrbStack's CLIs (orb, orbctl; docker is also linked into
      # /usr/local/bin). OrbStack's own way is a ~/.zprofile it writes once,
      # which only login shells read and this repo does not keep
      my.path = [ "${config.home.homeDirectory}/.orbstack/bin" ];

      # $devstack in herdr's sidebar: the worktree has its minitube devstack
      # running, a compose project started from its compose.devstack.yaml.
      # minitube's devstacks run only on this Mac.
      my.herdrWorktreeStatus.devstack = {
        repos = [ "minitube" ];
        mark = "dev";
        condition = ''
          test -f compose.devstack.yaml &&
            docker compose ls --format json | jq -e --arg d "$PWD" 'any(.[];
              (.ConfigFiles | split(",") | index($d + "/compose.devstack.yaml"))
              and (.Status | test("running")))'
        '';
      };

      # The shipped skill tells agents to prefer agent-browser over any other
      # browser tool; claude-in-chrome stays the default, so rewrite its
      # description to trigger only when agent-browser is asked for by name.
      my.skills.agent-browser = pkgs.runCommand "agent-browser-skill" { } ''
        mkdir $out
        sed '/^description:/c\
        description: Browser automation CLI for AI agents. Use only when the user explicitly asks for agent-browser; otherwise use the default browser tools.' \
          ${pkgs.agent-browser}/skills/agent-browser/SKILL.md > $out/SKILL.md
      '';

      my.masApps = {
        "CleanMyDrive 2" = 523620159;
        "Fantastical" = 975937182;
        "LINE" = 539883307;
        "Picview" = 6452016140;
        "PopClip" = 445189367; # the work Mac has the cask versions of these two
        "The Unarchiver" = 425424353;
        "Translate Tab" = 458887729;
      };
    };
}
