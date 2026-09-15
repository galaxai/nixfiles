{ inputs, pkgs, ... }:

{
  home.packages = [
    pkgs.t3code
    inputs.nix-codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
