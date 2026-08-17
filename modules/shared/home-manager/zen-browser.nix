{ inputs, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    # Let the browser find 1Password's native-messaging manifest so the
    # extension can talk to the desktop app.
    nativeMessagingHosts = lib.optionals isLinux [ pkgs._1password-gui ];

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;

      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;

      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;

      OfferToSaveLogins = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # Installed from addons.mozilla.org on first launch; auto-updated by
      # the browser afterwards.  normal_installed = user can disable them in
      # about:addons but not uninstall.
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        };
      };
    };

    profiles.default.settings =
      {
        "accessibility.force_disabled" = 1;
        "gfx.webrender.all" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.view.sidebar-expanded" = false;
        "zen.view.compact.enable-at-startup" = false;

        # Toolbar layout mirrored from the macOS profile.  Managed here, so
        # in-browser toolbar customization is reverted on the next restart.
        "browser.uiCustomization.state" = builtins.toJSON {
          placements = {
            widget-overflow-fixed-list = [ ];
            unified-extensions-area = [ ];
            nav-bar = [
              "back-button"
              "forward-button"
              "stop-reload-button"
              "customizableui-special-spring1"
              "vertical-spacer"
              "urlbar-container"
              "customizableui-special-spring2"
              "unified-extensions-button"
              "ublock0_raymondhill_net-browser-action"
              "_d634138d-c276-4fc8-924b-40a0ea21d284_-browser-action"
              "reset-pbm-toolbar-button"
            ];
            TabsToolbar = [ "tabbrowser-tabs" ];
            vertical-tabs = [ ];
            PersonalToolbar = [
              "import-button"
              "personal-bookmarks"
            ];
            zen-sidebar-top-buttons = [ "zen-toggle-compact-mode" ];
            zen-sidebar-foot-buttons = [
              "downloads-button"
              "zen-workspaces-button"
              "zen-create-new-button"
            ];
          };
          currentVersion = 24;
        };
      }
      // lib.optionalAttrs isLinux {
        "widget.gtk.rounded-bottom-corners.enabled" = false;
      };
  };
}
