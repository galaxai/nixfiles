{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  pinnedPkgs = import inputs.nixpkgs-discord {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  inherit (pinnedPkgs) discord;
in
{
  programs.discord = {
    enable = true;
    package = discord;
    configName = "discord";
    settings = {
      autoUpdate = false;
      autoLaunch = true;
      SKIP_HOST_UPDATE = true;
    };
  };

  # Finder launches the app directly, bypassing Nix's command-line wrapper.
  home.activation.discordModules = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run ${discord.stageModules} "${discord}/share/discord/modules"
    ''
  );
}
