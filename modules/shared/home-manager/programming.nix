{ pkgs, ... }:

{
  home.packages = with pkgs; [
    lazydocker
    pre-commit
    uv
    bun
    nodejs
    nil
    nixd
  ];

  programs.zed-editor = {
    enable = true;
    installRemoteServer = true;
  };
}
