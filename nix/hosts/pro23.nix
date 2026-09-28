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
      my.skills.agent-browser = "${pkgs.agent-browser}/skills/agent-browser";

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
