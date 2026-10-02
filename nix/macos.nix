# macOS System Settings shared by all Macs. Only choices are declared;
# anything left at the macOS default is not listed. Dock contents, Finder
# sidebar, display scaling, fingerprints and input sources stay manual
# (see docs/guides/setup-mac.md).
{ ... }:
{
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true; # Appearance: Auto
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "WhenScrolling";
      "com.apple.trackpad.scaling" = 1.5;
    };
    ".GlobalPreferences"."com.apple.mouse.scaling" = 1.0;

    dock = {
      autohide = true;
      orientation = "left";
      tilesize = 34;
      magnification = true;
      largesize = 52;
      mru-spaces = false;
      expose-group-apps = false;
      # Hot corners: 1 none, 2 Mission Control, 4 Desktop, 10 display sleep
      wvous-tl-corner = 1;
      wvous-tr-corner = 2;
      wvous-bl-corner = 10;
      wvous-br-corner = 4;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # list view
      NewWindowTarget = "Desktop";
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      ShowHardDrivesOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;
      ShowMountedServersOnDesktop = true;
    };

    trackpad = {
      Clicking = true; # tap to click
      # Accessibility > Pointer Control: dragging with drag lock
      Dragging = true;
      DragLock = true;
      TrackpadThreeFingerDrag = false;
    };

    menuExtraClock = {
      ShowAMPM = true;
      ShowDate = 1; # always
      ShowDayOfWeek = true;
      FlashDateSeparators = false;
    };

    controlcenter = {
      Sound = true; # always show in the menu bar
      BatteryShowPercentage = true;
    };

    hitoolbox.AppleFnUsageType = "Change Input Source";

    loginwindow.GuestEnabled = false;
  };

  # Applied with hidutil to every keyboard, at each switch and at boot
  # (org.nixos.activate-system)
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Touch ID for sudo; reattach makes it work inside herdr
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
