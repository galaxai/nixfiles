> Hi those are my personal nix/dot files

They are ment to be used for darwin systems (my laptop) and \
nixos systems soon to be my main pc.

[!NOTE]

Linux part of nix files wasn't tested yet as it was copy pasted from old nixos machine.

# Installation

1. > Burn usb with [caligula](https://github.com/ifd3f/caligula)
```bash
caligula burn <path>
```
2. Install nix on your disctro of choice
3. Enable flakes
```bash
#/etc/nix/nix.conf
experimental-features = nix-command flakes
```
4. Install home-manager
5. Install packges
```bash
sudo <darwin|nixos>-rebuild switch --flake .#<darwin|nixos>
```
