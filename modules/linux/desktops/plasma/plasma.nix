{ lib, ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

    # Flat pointer acceleration profile (raw 1:1 mouse input).
    # KDE matches devices by exact name/vendor/product, so both mice
    # are listed; the Bridge75 name really has two leading spaces.
    input.mice = [
      {
        name = "  Bridge75 Mouse";
        vendorId = "fffe";
        productId = "003e";
        accelerationProfile = "none";
      }
      {
        name = "ATTACK SHARK R6 Mouse";
        vendorId = "373e";
        productId = "0021";
        accelerationProfile = "none";
      }
    ];

    kscreenlocker = {
      autoLock = false;
      lockOnResume = false;
      lockOnStartup = false;
    };

    powerdevil.AC = {
      autoSuspend.action = "nothing";
      dimDisplay.enable = false;
      turnOffDisplay.idleTimeout = "never";
    };

    configFile = {
      # 0 = the "Instant" end of the Plasma animation-speed slider;
      # disables all desktop animations globally.
      kdeglobals.KDE.AnimationDurationFactor = 0;

      kdeglobals.General = {
        BrowserApplication = "zen-beta.desktop";
        TerminalApplication = "ghostty";
        TerminalService = "com.mitchellh.ghostty.desktop";
      };

      krunnerrc.General = {
        FreeFloating = true;
        historyBehavior = "ImmediateCompletion";
      };
    };
  };

  xdg.mimeApps = {
    enable = true;

    # Plasma uses the text/plain MIME association as its default editor.
    defaultApplications."text/plain" =
      lib.mkForce [ "dev.zed.Zed.desktop" ];
  };
}
