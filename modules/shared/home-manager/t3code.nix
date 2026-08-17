{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.nix-t3code.packages.${pkgs.stdenv.hostPlatform.system}.t3code-nightly
  ];
}
