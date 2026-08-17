{ pkgs, ... }:
{
  # Vesktop, not pkgs.discord: the nixpkgs Darwin discord patches the app bundle
  # after Discord signed it, which breaks the sealed signature. macOS then refuses
  # to launch it ("Discord is damaged"). Vesktop is arm64-native and ad-hoc signed
  # at build time, so it launches cleanly.
  home.packages = with pkgs; [
    vesktop
  ];
}
