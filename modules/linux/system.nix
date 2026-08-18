{ pkgs, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ./programs/_1password.nix
    ./programs/gaming.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  console.keyMap = "pl2";

  services.keyd = {
    enable = true;
    keyboards.bridge75 = {
      ids = [ "fffe:003e" ];
      settings = {
        main = {
          # macOS bottom row: Control, Option (Windows), Command (Alt).
          leftalt = "layer(command)";
          leftmeta = "layer(option)";
        };

        "command:C" = {
          # Keep copy/paste/cut usable in both graphical apps and terminals.
          c = "C-insert";
          v = "S-insert";
          x = "S-delete";

          # Match macOS navigation and KDE application switching.
          left = "home";
          right = "end";
          up = "C-home";
          down = "C-end";
          space = "A-space";
          tab = "A-tab";
          grave = "A-grave";
        };

        "option:A" = {
          left = "C-left";
          right = "C-right";
          up = "C-up";
          down = "C-down";
          backspace = "C-backspace";
          delete = "C-delete";
        };
      };
    };
  };

  # This is a desktop: do not enter any system sleep state automatically or
  # through dedicated suspend/hibernate keys.
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };

  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.billy = {
    isNormalUser = true;
    description = "billy";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
  ];

  programs.nix-ld.enable = true;
  # fuse (fuse2) provides libfuse.so.2, needed by AppImages and other
  # prebuilt binaries run through nix-ld.
  programs.nix-ld.libraries = with pkgs; [ fuse ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PasswordAuthentication = true;
  };

  services.tailscale.enable = true;

  system.stateVersion = "26.05";
}
