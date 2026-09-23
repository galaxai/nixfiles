{ pkgs, inputs, ... }:

let
  # t3code and codex release several times a week; nixos-unstable-small
  # picks them up hours after merge instead of days.
  small = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    small.t3code
    small.codex
  ];
}
