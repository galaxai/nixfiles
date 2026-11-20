{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  discord = pkgs.discord-canary;
in
{
  programs.discord = {
    enable = true;
    package = discord;
    configName = "discordcanary";
    settings = {
      autoUpdate = true;
      autoLaunch = true;
      SKIP_HOST_UPDATE = true;
    };
  };

  # Finder launches the app directly, bypassing Nix's command-line wrapper.
  home.activation.discordCanaryModules = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${discord.stageModules} "${discord}/share/discord-canary/modules"
    ''
  );
}
