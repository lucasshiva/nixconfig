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

                if [ -e "$prefix" ] || [ -L "$prefix" ]; then
                  echo "Removing incomplete MusicBee Wine prefix: $prefix"
                  rm -rf -- "$prefix"
                fi

                mkdir -p $WINEPREFIX
                wineboot -u
                ln -sfn "$mount_point" "$WINEPREFIX/dosdevices/$drive_letter"

                dotnet_payload_url="https://web.archive.org/web/2000/http://download.windowsupdate.com/msdownload/update/software/svpk/2011/02/windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe"

                # Ensure we're not getting an error from web.archive, which stops the script.
                status_code="$(
                  curl \
                    --location \
                    --silent \
                    --output /dev/null \
                    --write-out '%{http_code}' \
                    --retry 3 \
                    --retry-delay 5 \
                    --retry-all-errors \
                    "$dotnet_payload_url"
                )"

                if [ "$status_code" = "429" ]; then
                  echo "web.archive.org is rate-limiting the required .NET download (HTTP 429)." >&2
                  echo "Wait and run setup-musicbee again; the Wine prefix was not modified." >&2
                  exit 1
                fi

                if [ "$status_code" -lt 200 ] || [ "$status_code" -ge 400 ]; then
                  echo "Required .NET download is unavailable (HTTP $status_code)." >&2
                  exit 1
                fi

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
