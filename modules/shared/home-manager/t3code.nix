{ pkgs, inputs, ... }:

let
  # t3code and codex release several times a week; nixos-unstable-small
  # picks them up hours after merge instead of days.
  small = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    (small.t3code.override {
      # Avoid the broken Electron 44 source build on Linux.
      t3code-unwrapped = small.t3code.unwrapped.override {
        electron_44 = small.electron_44-bin;
      };
    })
    small.codex
  ];
}
