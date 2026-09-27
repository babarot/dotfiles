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
      # On trial: agent harness tools and the skills they ship. Move each
      # to its own nix/home/tools/<tool>.nix once it stays.
      home.packages = with pkgs; [
        agent-browser
        hunk
        tuicr
      ];
      my.skills = {
        agent-browser = "${pkgs.agent-browser}/skills/agent-browser";
        hunk-review = "${pkgs.hunk}/share/skills/hunk/hunk-review";
        # Not in the package; taken from the same release's source
        tuicr = "${pkgs.tuicr.src}/skills/tuicr";
      };

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
