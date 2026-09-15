{
  description = "Unified NixOS and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    plasma-manager.url = "github:nix-community/plasma-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helium-browser = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-codex-cli = {
      url = "github:sadjow/codex-cli-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";

      linuxHomeModule = {
        imports = [
          ./modules/shared/home.nix
          inputs.plasma-manager.homeModules.plasma-manager
          ./modules/linux/home-manager/discord.nix
          ./modules/linux/home-manager/ssh.nix
          ./modules/linux/desktops/plasma/plasma.nix
        ];

        home.username = "billy";
        home.homeDirectory = "/home/billy";
        home.stateVersion = "25.11";
      };

      darwinHomeModule = {
        imports = [
          ./modules/shared/home.nix
          ./modules/darwin/home-manager/shell.nix
          ./modules/darwin/home-manager/discord.nix
        ];

        home.username = "apple";
        home.homeDirectory = "/Users/apple";
        home.stateVersion = "25.11";
      };
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/linux/system.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.backupFileExtension = "backup";
            home-manager.overwriteBackup = true;
            home-manager.users.billy = linuxHomeModule;
          }
        ];
      };

      darwinConfigurations."darwin" = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        specialArgs = { inherit self inputs; };
        modules = [
          ./modules/darwin/system.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.backupFileExtension = "backup";
            home-manager.users.apple = darwinHomeModule;
          }
        ];
      };
    };
}
