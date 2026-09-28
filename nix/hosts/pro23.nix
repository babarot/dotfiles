# Private Mac. Put settings that only this machine needs here.
{ ... }:
{
  # Vendor apps only for this Mac (see nix/homebrew.nix)
  homebrew.casks = [
    "autodesk-fusion"
    "bambu-studio"
    "discord"
    "google-drive"
    "logi-options+"
    "parallels"
    "postman"
  ];

  home-manager.users.babarot =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.agent-browser ];

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
        "Spark Desktop" = 6445813049;
        "The Unarchiver" = 425424353;
        "Translate Tab" = 458887729;
      };
    };
}
