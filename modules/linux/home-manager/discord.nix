{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord-canary
  ];

  programs.discord = {
    enable = true;
    settings = {
      autoUpdate = true;
      autoLaunch = true;
      SKIP_HOST_UPDATE = true;
    };
  };
}
