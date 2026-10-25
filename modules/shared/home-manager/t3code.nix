{ pkgs, inputs, ... }:

let
  # t3code and codex release several times a week; nixos-unstable-small
  # picks them up hours after merge instead of days.
  small = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    (
      (small.t3code.override {
        # Avoid the broken Electron 44 source build on Linux.
        t3code-unwrapped = small.t3code.unwrapped.override {
          electron_44 = small.electron_44-bin;
        };
      }).overrideAttrs
        (old: {
          # Terminals launched by Electron apps can inherit this variable.
          # The desktop entry point must run as Electron, rather than Node.
          buildCommand = old.buildCommand + ''
            wrapProgram "$out/bin/t3code-desktop" --unset ELECTRON_RUN_AS_NODE
          '';
        })
    )
    small.codex
  ];
}
