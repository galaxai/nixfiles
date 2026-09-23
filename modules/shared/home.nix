{ config, lib, ... }:

let
  configDir = "${config.home.homeDirectory}/nixfiles/config";
  mkOutOfStore = config.lib.file.mkOutOfStoreSymlink;

  sharedConfigs = {
    "nix/nix.conf" = {
      target = "nix/nix.conf";
      recursive = false;
    };
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
    ./home-manager/fastfetch
    ./home-manager/programming.nix
    ./home-manager/fonts.nix
    ./home-manager/zen-browser.nix
    ./home-manager/t3code.nix
  ];

  xdg.configFile = lib.mapAttrs' (
    name: entry:
    lib.nameValuePair entry.target {
      source = mkOutOfStore "${configDir}/${
        if entry.target == "starship.toml" then "starship" else name
      }";
      inherit (entry) recursive;
    }
  ) sharedConfigs;

  programs.git = {
    enable = true;
    settings = {
      user.name = "GalaxAI";
      user.email = "92019780+GalaxAI@users.noreply.github.com";
      # `git url` opens the current repo/branch on GitHub in the browser.
      alias.url = "!gh browse";
    };
    includes = [
      {
        # Work identity lives outside the repo; git skips this include if the file is missing.
        condition = "gitdir:~/work/";
        path = "~/.config/git/work";
      }
    ];
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.home-manager.enable = true;
}
