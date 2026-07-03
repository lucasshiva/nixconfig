{ lib, ... }:
{
  den.aspects.apps.musicbee = {
    homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.my.musicbee;
      in
      {
        options.my.musicbee = {
          portableAppDir = lib.mkOption {
            type = lib.types.str;
            description = ''
              Directory containing an existing MusicBee Portable installation.
              This directory must contain `MusicBee.exe` and `MusicBee.png`.
            '';
            example = "/mnt/commondata/Apps/MusicBee";
          };
          libraryMountPoint = lib.mkOption {
            type = lib.types.str;
            description = ''
              Host directory exposed to MusicBee as a Windows drive.
              This should be the mount point containing the music library.
            '';
            example = "/mnt/commondata";
          };
          libraryDriveLetter = lib.mkOption {
            type = lib.types.str;
            description = ''
              Windows drive letter used to expose libraryMountPoint inside the MusicBee Wine prefix.
              Use a single lowercase letter, without a colon.
            '';
            example = "f";
          };
          winePrefix = lib.mkOption {
            type = lib.types.str;
            description = "Where to setup the Wine prefix for MusicBee.";
            default = "${config.home.homeDirectory}/wineprefixes/musicbee";
          };
        };

        config = {
          home.packages = with pkgs; [
            # Ensure we have wine and winetricks installed.
            wineWow64Packages.stable
            winetricks

            (pkgs.writeShellScriptBin "setup-musicbee" ''
              set -euo pipefail

              prefix="${cfg.winePrefix}"
              app_dir="${cfg.portableAppDir}"
              drive_letter="${cfg.libraryDriveLetter}:"
              mount_point="${cfg.libraryMountPoint}"

              if [ ! -f "$app_dir/MusicBee.exe" ]; then
                echo "MusicBee.exe was not found in: $app_dir" >&2
                echo "Install MusicBee Portable there before running setup-musicbee." >&2
                exit 1
              fi

              export WINEPREFIX="$prefix";

              # Ignore warnings about wine-mono — we don't need it.
              export WINEDLLOVERRIDES="mscoree,mshtml="

              # Hide debug messages
              export WINEDEBUG="-all"

              if [ ! -f "$prefix/.prefix-initialized" ]; then
                echo "Setting up prefix. Ignore warnings about 64-bit prefix or wow64 mode."
                mkdir -p $WINEPREFIX
                wineboot -u
                ln -sfn "$mount_point" "$WINEPREFIX/dosdevices/$drive_letter"

                # Unset display to prevent wine from displaying configuration messages.
                DISPLAY="" WAYLAND_DISPLAY="" winetricks --unattended dotnet48 xmllite gdiplus cjkfonts wmp11
                winetricks --unattended windowmanagerdecorated=n

                touch "$prefix/.prefix-initialized"
              fi

              echo "MusicBee setup complete"
            '')
          ];

          xdg.desktopEntries = {
            musicbee = {
              type = "Application";
              name = "MusicBee";
              icon = "${cfg.portableAppDir}/MusicBee.png";
              comment = "The Ultimate Music Player and Manager";
              exec = ''
                env WINEPREFIX=${cfg.winePrefix} wine "${cfg.portableAppDir}/MusicBee.exe"
              '';
              categories = [
                "AudioVideo"
                "Audio"
                "Music"
                "Player"
              ];
              mimeType = [
                "audio/mp4"
                "audio/mpeg"
                "audio/aac"
                "audio/flac"
                "audio/ogg"
              ];
            };
          };
        };
      };
  };
}
