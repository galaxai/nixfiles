{ pkgs, ... }:

{
  # Steam, configured the NixOS way so it pulls in the 32-bit libraries and
  # Proton support that most games rely on.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Let games request an on-demand performance profile.
  programs.gamemode.enable = true;

  # Steam and Wine both need 32-bit graphics libraries.
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
    qbittorrent

    # Lutris installs and launches Battle.net (World of Warcraft) through Wine
    # and manages the Wine runner for it.
    lutris
    wineWow64Packages.stable
    winetricks
  ];
}
