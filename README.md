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

For subsequent rebuilds, use `nh` (which supports macOS via `nh darwin`):

```sh
nix run nixpkgs#nh -- darwin switch . --hostname darwin
```

Once applied, this configuration installs `nh` and defaults its flake path to
`/Users/apple/nixfiles`, so `nh darwin switch --hostname darwin` works from any
directory. `nh` requests elevated privileges when needed.

### NixOS

```sh
nh os switch --hostname nixos
```

If `nh` is not installed yet, run it through Nix from the repository directory:

```sh
nix run nixpkgs#nh -- os switch . --hostname nixos
```

On NixOS, this configuration installs `nh` and defaults its flake path to
`/home/billy/nixfiles`.

On both systems, `nh clean` runs weekly and keeps at least five generations
plus anything from the last 14 days.

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
