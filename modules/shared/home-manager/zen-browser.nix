{ inputs, pkgs, lib, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

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
    };

    profiles.default.settings =
      {
        "accessibility.force_disabled" = 1;
        "gfx.webrender.all" = true;
        "zen.view.use-single-toolbar" = false;
        "zen.view.sidebar-expanded" = false;

      }
      // lib.optionalAttrs isLinux {
        "widget.gtk.rounded-bottom-corners.enabled" = false;
      };
  };
}
