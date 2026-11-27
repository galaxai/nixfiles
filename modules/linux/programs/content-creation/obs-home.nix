{
  config,
  lib,
  pkgs,
  ...
}:

let
  name = "Content Creation";
  directory = "Content_Creation";
  recordingDirectory = "${config.home.homeDirectory}/Videos/OBS";
  # These match the PipeWire application identifiers on this PC.
  discordApplication = ".Discord-wrapped";
  browserApplication = "zen";
  # Set this to the game's PipeWire application name, or select it in OBS.
  gameApplication = "__select_game_in_obs__";

  audioSource = sourceName: sourceId: tracks: settings: {
    name = sourceName;
    id = sourceId;
    versioned_id = sourceId;
    inherit settings;
    # OBS stores track assignments as a bitmask (track 1 = bit 0).
    mixers = lib.foldl' (mask: track: mask + builtins.elemAt [ 1 2 4 8 16 32 ] (track - 1)) 0 tracks;
    volume = 1.0;
    muted = false;
    monitoring_type = 0;
  };
  appSource =
    sourceName: application: tracks:
    audioSource sourceName "pipewire_audio_application_capture" tracks {
      CaptureMode = 0;
      MatchPriorty = 0; # Spelling used by the plugin's settings format.
      ExceptApp = false;
      TargetName = application;
    };
  sources = [
    (appSource "Game" gameApplication [
      1
      2
      3
    ])
    (audioSource "Microphone" "pulse_input_capture" [ 1 2 4 ] {
      device_id = "default";
    })
    (appSource "Discord" discordApplication [
      1
      5
    ])
    (appSource "Browser" browserApplication [
      1
      6
    ])
  ];
  scene = pkgs.writeText "obs-content-creation.json" (
    builtins.toJSON {
      inherit name;
      current_scene = name;
      current_program_scene = name;
      current_transition = "Fade";
      scene_order = [ { inherit name; } ];
      # No global Desktop Audio or Mic/Aux: capture each source exactly once.
      sources = sources ++ [
        {
          inherit name;
          id = "scene";
          settings.items = lib.imap0 (index: source: {
            inherit (source) name;
            id = index + 1;
            visible = true;
            pos = {
              x = 0.0;
              y = 0.0;
            };
            scale = {
              x = 1.0;
              y = 1.0;
            };
          }) sources;
        }
      ];
    }
  );
  profile = pkgs.writeText "obs-content-creation.ini" (
    lib.generators.toINI { } {
      General.Name = name;
      Output.Mode = "Advanced";
      AdvOut = {
        TrackIndex = 1;
        VodTrackEnabled = true;
        VodTrackIndex = 2;
        RecType = "Standard";
        RecFilePath = recordingDirectory;
        RecFormat2 = "mkv";
        RecTracks = 63; # All six tracks, including both mixes.
        Track1Name = "Live mix";
        Track2Name = "VOD mix (game + microphone)";
        Track3Name = "Game";
        Track4Name = "Microphone";
        Track5Name = "Discord";
        Track6Name = "Browser";
      };
      Audio = {
        SampleRate = 48000;
        ChannelSetup = "Stereo";
      };
    }
  );
  launcher = pkgs.writeShellApplication {
    name = "obs-content-creation";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.procps
    ];
    text = ''
      # OBS rewrites its settings. Copy templates to writable files and refresh
      # only when the Nix template changes, preserving edits between launches.
      if pgrep -u "$(id -u)" -x 'obs|\.obs-wrapped' >/dev/null; then
        echo "Close OBS before launching the Content Creation profile." >&2
        exit 1
      fi
      obs_config="''${XDG_CONFIG_HOME:-$HOME/.config}/obs-studio"
      template_state="''${XDG_STATE_HOME:-$HOME/.local/state}/obs-content-creation"
      mkdir -p "$template_state" ${lib.escapeShellArg recordingDirectory}

      install_template() {
        local template="$1" destination="$2" marker="$3"
        if [[ ! -f "$destination" || ! -f "$marker" ]] ||
           [[ "$(cat "$marker")" != "$template" ]]; then
          mkdir -p "$(dirname "$destination")"
          if [[ -e "$destination" ]]; then
            cp --backup=numbered "$destination" "$destination.before-nix"
          fi
          install -m 600 "$template" "$destination"
          printf '%s\n' "$template" > "$marker"
        fi
      }

      install_template ${profile} "$obs_config/basic/profiles/${directory}/basic.ini" "$template_state/profile"
      install_template ${scene} "$obs_config/basic/scenes/${directory}.json" "$template_state/scene"
      exec obs --profile ${lib.escapeShellArg name} --collection ${lib.escapeShellArg name} "$@"
    '';
  };
in
{
  home.packages = [ launcher ];
  xdg.desktopEntries.obs-content-creation = {
    name = "OBS Content Creation";
    comment = "Stream and record with separate game, microphone, Discord and browser audio";
    exec = "${lib.getExe launcher}";
    icon = "com.obsproject.Studio";
    categories = [
      "AudioVideo"
      "Recorder"
    ];
    terminal = false;
  };
}
