{ pkgs, ... }:
{
  programs.discord = {
    enable = true;
    package = pkgs.discord-canary;
    settings = {
      autoUpdate = true;
      autoLaunch = true;
      SKIP_HOST_UPDATE = true;
    };
  };
}
