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

After applying this configuration, you can also use `nh`:

```sh
nh os switch --hostname nixos
```

`nh` defaults to `/home/billy/nixfiles`. Automatic generation cleanup is not
enabled, so rollback retention remains manually managed.

## Format and check

Format the Nix files, excluding the generated hardware configuration:

```sh
nix fmt
```

Check formatting, lint with Statix and deadnix, and evaluate the flake on the
current platform:

```sh
nix flake check
```

GitHub Actions runs these same checks on pushes and pull requests, and explicitly
evaluates the macOS configuration. The generated hardware configuration is
excluded from formatting and linting. Statix allows dotted option assignments
to preserve the module style used here.

## Update dependencies

```sh
nix flake update
```
