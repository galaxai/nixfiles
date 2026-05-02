{ config, ... }:

let
  config_dir = "./config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{
  xdg.configFile = {
    "krunnerrc".source = create_symlink "${config_dir}/krunnerrc";
    "kdeglobals".source = create_symlink "${config_dir}/kdeglobals";
  };
}
