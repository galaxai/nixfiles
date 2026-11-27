# Content creation

`obs.nix` installs OBS and the PipeWire application audio capture plugin.
`obs-home.nix` generates an editable OBS profile and scene collection. After
rebuilding NixOS, launch **OBS Content Creation** from the application menu or run
`obs-content-creation`.

| Track | Sources | Use |
| --- | --- | --- |
| 1 | Game, microphone, Discord, browser | Live stream / full playback mix |
| 2 | Game, microphone | Twitch VOD / clean playback mix |
| 3 | Game | Editing |
| 4 | Microphone | Editing |
| 5 | Discord | Editing |
| 6 | Browser | Editing |

Recordings go to `~/Videos/OBS` as MKV files containing all six audio tracks.
Normal players play one track at a time; use an editor to mix the isolated tracks.
The microphone remains audible in both mixes and is also saved separately on
track 4. To omit it from a mix, remove that track from its assignment in
`obs-home.nix` or Advanced Audio Properties.

## First launch

1. In the Game audio source properties, select the running game. Alternatively,
   set `gameApplication` in Nix to its PipeWire application identifier. The
   initial placeholder deliberately captures nothing.
2. Check that Microphone captures the desired default input. Choose a specific
   device in its properties if necessary.
3. Add your screen/window capture source and select the screen or window in the
   desktop sharing dialog. The generated scene initially contains audio only.
4. Choose an appropriate video encoder/resolution and connect your streaming
   account in OBS. Credentials stay in OBS's writable configuration.
5. Make a short recording and check each track before streaming.

Discord targets `.Discord-wrapped`, and Browser targets `zen`, matching
this PC's PipeWire identifiers when configured. Update the variables if apps
change. Keep global Desktop Audio disabled to avoid recapturing excluded apps.
Browser capture includes the browser's audio, not an individual tab.

The Twitch VOD option uses track 2 when connected to Twitch. For YouTube, choose
track 2 as the streaming track if Discord/browser must be absent from both the
live stream and archive, or upload an edited local recording afterwards.

## Updating the configuration

The launcher copies Nix templates into OBS's writable configuration on first
launch. GUI edits survive subsequent launches and rebuilds when the relevant
template is unchanged. Changing a template in Nix replaces the corresponding
profile INI or scene JSON on the next launch; the previous file is backed up
beside it as `*.before-nix` (older backups are numbered). Scene changes in Nix
therefore require reapplying any GUI-added video sources, or restoring them from
the backup. Other profiles, collections and streaming credentials are retained.

Close OBS before using the launcher. It never starts recording or streaming
automatically.
