{ lib, ... }:

{
  programs.bash.profileExtra = lib.mkAfter ''
    export PATH=/run/current-system/sw/bin:$PATH
  '';

  programs.bash.bashrcExtra = lib.mkAfter ''
    export PATH=/run/current-system/sw/bin:$PATH
    alias home-manager="darwin-rebuild"
  '';
}
