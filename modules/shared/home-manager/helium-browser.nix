{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
