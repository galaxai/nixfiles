{ pkgs, lib, ... }:

let
  logoPng = ./logo.png;

  # Nix has no \u string escapes, so build a real ESC byte for ANSI colors.
  esc = builtins.fromJSON ''"\u001b"'';

  # Box borders at a fixed inner width with the label centered.
  width = 52;
  line = n: lib.concatStrings (lib.replicate n "─");
  boxTop =
    label:
    let
      left = (width - lib.stringLength label) / 2;
    in
    "${esc}[90m┌${line left}${label}${line (width - lib.stringLength label - left)}┐";
  boxBottom = "${esc}[90m└${line width}┘";

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        type = "kitty-direct";
        source = "${logoPng}";
        # thank you https://github.com/seatedro/glyph
        height = 20;
        width = 40;
        padding = {
          top = 5;
          left = 3;
        };
      };

      modules = [
        "break"
        {
          type = "custom";
          format = boxTop "Hardware";
        }
        {
          type = "title";
          format = " {6}{7}{8}";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "│ ├ CPU";
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├ GPU";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "│ ├ memory";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "└ └ disk";
          keyColor = "green";
        }
        {
          type = "custom";
          format = boxBottom;
        }
        "break"
        {
          type = "custom";
          format = boxTop "Software";
        }
        {
          type = "os";
          key = " OS";
          keyColor = "yellow";
        }
        {
          type = "kernel";
          key = "│ ├kernel";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├packages";
          keyColor = "yellow";
        }
        {
          type = "shell";
          key = "└ └ shell";
          keyColor = "yellow";
        }
        "break"
        {
          type = "de";
          key = " DE";
          keyColor = "blue";
        }
        {
          type = "lm";
          key = "│ ├lm";
          keyColor = "blue";
        }
        {
          type = "wm";
          key = "│ ├wm";
          keyColor = "blue";
        }
        {
          type = "wmtheme";
          key = "│ ├theme";
          keyColor = "blue";
        }
        {
          type = "terminal";
          key = "└ └terminal";
          keyColor = "blue";
        }
        {
          type = "custom";
          format = boxBottom;
        }
        "break"
        {
          type = "custom";
          format = boxTop "Uptime / Age / DT";
        }
        {
          type = "command";
          key = "  OS Age ";
          keyColor = "magenta";
          # GNU stat on Linux, BSD stat on macOS.
          text =
            if isDarwin then
              "birth_install=$(stat -f %B /); current=$(date +%s); echo $(((current - birth_install) / 86400)) days"
            else
              "birth_install=$(stat -c %W /); current=$(date +%s); echo $(((current - birth_install) / 86400)) days";
        }
        {
          type = "uptime";
          key = "  Uptime ";
          keyColor = "magenta";
        }
        {
          type = "datetime";
          key = "  DateTime ";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = boxBottom;
        }
        "break"
        {
          type = "colors";
          paddingLeft = 3;
          symbol = "circle";
        }
        "break"
      ];
    };
  };
}
