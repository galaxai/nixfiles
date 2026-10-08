{ lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  discord =
    if isDarwin then
      pkgs.discord-canary.overrideAttrs (old: {
        # Keep Nix's pinned modules outside the signed bundle so macOS accepts it.
        postInstall = (old.postInstall or "") + ''
          mkdir -p "$out/lib/discord-canary"
          mv "$out/Applications/Discord Canary.app/Contents/Resources/modules" \
            "$out/lib/discord-canary/modules"
          substituteInPlace "$out/bin/Discord Canary" \
            --replace-fail "$out/Applications/Discord Canary.app/Contents/Resources/modules" \
              "$out/lib/discord-canary/modules"
          /usr/bin/codesign --verify --deep --strict "$out/Applications/Discord Canary.app"
        '';
      })
    else
      pkgs.discord-canary;
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
      run ${discord.stageModules} "${discord}/lib/discord-canary/modules"
    ''
  );
}
