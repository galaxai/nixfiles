{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.packages =
    (with pkgs; [
      lazydocker
      pre-commit
      uv
      bun
      nodejs
      nil
      nixd
    ])
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      inputs.delta.packages.${pkgs.stdenv.hostPlatform.system}.delta
    ];

  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
  };
}
