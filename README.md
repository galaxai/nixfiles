# nixfiles

My personal, unified Nix configuration for macOS and NixOS.

## Systems

- **macOS** (`aarch64-darwin`) using nix-darwin and Home Manager.
  Flake output: `.#darwin`
- **NixOS** (`x86_64-linux`) using Home Manager and Plasma Manager.
  Flake output: `.#nixos`

This repository is tailored to my machines and user accounts rather than being
a general-purpose Nix configuration.

## Apply the configuration

Clone the repository and run the command for the target system.

### macOS

Install Nix first. For the initial nix-darwin installation, run:

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#darwin
```

For subsequent rebuilds:

```sh
sudo darwin-rebuild switch --flake .#darwin
```

### NixOS

```sh
sudo nixos-rebuild switch --flake .#nixos
```

## Update dependencies

```sh
nix flake update
```
