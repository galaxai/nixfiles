{ lib, ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      lookAndFeel = "org.kde.breezedark.desktop";
    };

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
    defaultApplications."text/plain" = lib.mkForce [ "dev.zed.Zed.desktop" ];
  };
}
