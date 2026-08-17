{ config, lib, ... }:

let
  configDir = "${config.home.homeDirectory}/nixfiles/config";
  mkOutOfStore = config.lib.file.mkOutOfStoreSymlink;

  sharedConfigs = {
    zed = {
      target = "zed";
      recursive = true;
    };
    ghostty = {
      target = "ghostty";
      recursive = true;
    };
    starship = {
      target = "starship.toml";
      recursive = false;
    };
  };
in
{
  imports = [
    ./home-manager/terminal.nix
    ./home-manager/programming.nix
    ./home-manager/fonts.nix
    ./home-manager/zen-browser.nix
    ./home-manager/helium-browser.nix
    ./home-manager/t3code.nix
  ];

  xdg.configFile =
    lib.mapAttrs'
      (name: entry:
        lib.nameValuePair entry.target {
          source = mkOutOfStore "${configDir}/${if entry.target == "starship.toml" then "starship" else name}";
          recursive = entry.recursive;
        })
      sharedConfigs;

  programs.git = {
    enable = true;
    settings = {
      user.name = "GalaxAI";
      user.email = "92019780+GalaxAI@users.noreply.github.com";
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        contents = {
          user = {
            name = "work-user";
            email = "work@example.com";
          };
        };
      }
    ];
  };

  programs.home-manager.enable = true;
}
