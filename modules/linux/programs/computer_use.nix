{ pkgs, ... }:

# Direct computer use: AgenticOS's `computer_use` capability driving this
# desktop through computerd (`deploy/computer/computerd.py` in agenticos, copied
# to ~/computer-use). Plasma here is Wayland-only, where xdotool and scrot reach
# nothing but XWayland windows, so computerd takes screenshots with Spectacle
# and sends input through dotool, a virtual keyboard and mouse on /dev/uinput.
#
# The daemon is full control of this desktop behind one token, so it is not
# started with the session, and the unit is switched off altogether until it is
# wanted again: set `enable = true` below, rebuild, then
#
#   systemctl --user start computerd      # http://127.0.0.1:8766
#   journalctl --user -u computerd -f
{
  # /dev/uinput for group `uinput`, rather than relying on Steam's udev rule.
  hardware.uinput.enable = true;
  users.users.billy.extraGroups = [ "uinput" ];

  environment.systemPackages = with pkgs; [
    dotool
    kdePackages.spectacle
    python3
  ];

  systemd.user.services.computerd = {
    enable = false;
    description = "computerd: this desktop, for AgenticOS computer use";
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = with pkgs; [
      dotool
      kdePackages.spectacle
    ];
    environment = {
      COMPUTERD_HOST = "127.0.0.1";
      # 8765 is the computerd in the agenticos-computer container.
      COMPUTERD_PORT = "8766";
      # dotool types through a keyboard layout; without it Polish letters are lost.
      DOTOOL_XKB_LAYOUT = "pl";
    };
    serviceConfig = {
      # COMPUTERD_TOKEN, the deployment's COMPUTER_DAEMON_TOKEN.
      EnvironmentFile = "%h/computer-use/computerd.env";
      ExecStart = "${pkgs.python3}/bin/python3 %h/computer-use/computerd.py";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
