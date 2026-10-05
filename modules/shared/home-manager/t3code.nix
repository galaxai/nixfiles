{ pkgs, inputs, ... }:

let
  # t3code and codex release several times a week; nixos-unstable-small
  # picks them up hours after merge instead of days.
  small = inputs.nixpkgs-small.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  # The desktop backend runs inside Electron, whose runtime cannot find the
  # C++ library needed by the bundled Linux node-pty module.
  t3code =
    if pkgs.stdenv.hostPlatform.isLinux then
      small.t3code.overrideAttrs (old: {
        buildCommand = old.buildCommand + ''
          for program in "$out/bin"/*; do
            wrapProgram "$program" \
              --prefix LD_LIBRARY_PATH : ${small.lib.makeLibraryPath [ small.stdenv.cc.cc.lib ]}
          done
        '';
      })
    else
      small.t3code;
in
{
  home.packages = [
    t3code
    small.codex
  ];
}
