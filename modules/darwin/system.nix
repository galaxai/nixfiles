{ self, pkgs, ... }:

{
  imports = [
    ./programs/_1password.nix
  ];

  users.users.apple = {
    name = "apple";
    home = "/Users/apple";
    shell = pkgs.bashInteractive;
  };

  environment.shells = [ pkgs.bashInteractive ];
  environment.systemPackages = with pkgs; [
    bashInteractive
    neovim
    tailscale
  ];
  services.tailscale.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;
}
