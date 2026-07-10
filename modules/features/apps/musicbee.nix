{ lib, ... }:
{
  shiv.apps.musicbee = {
    homeManager =
      { config, pkgs, ... }:
      let
        cfg = config.my.musicbee;
      in
      {
        options.my.musicbee = {
          appDir = lib.mkOption {
            type = lib.types.str;
            description = ''
              Directory containing an existing MusicBee Portable installation.
              This directory must contain `MusicBee.exe` and `MusicBee.png`.
            '';
            example = "/mnt/shared/MusicBee";
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

              archive_base_url="https://web.archive.org/"
              connect_timeout=15
              request_timeout=30

              echo "Checking whether web.archive.org is reachable..."

              status_code="$(
                curl \
                  --silent \
                  --show-error \
                  --location \
                  --connect-timeout "$connect_timeout" \
                  --max-time "$request_timeout" \
                  --output /dev/null \
                  --write-out '%{http_code}' \
                  "$archive_base_url" \
                || true
              )"

              if [ -z "$status_code" ] || [ "$status_code" = "000" ]; then
                echo "web.archive.org could not be reached." >&2
                exit 1
              fi

              if [ "$status_code" = "429" ]; then
                echo "web.archive.org is rate-limiting requests (HTTP 429)." >&2
                exit 1
              fi

              if [ "$status_code" -lt 200 ] || [ "$status_code" -ge 400 ]; then
                echo "web.archive.org returned an unexpected status (HTTP $status_code)." >&2
                exit 1
              fi

              echo "web.archive.org is reachable (HTTP $status_code)."

              prefix="${cfg.winePrefix}"
              app_dir="${cfg.appDir}"

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
              icon = "${cfg.appDir}/MusicBee.png";
              comment = "The Ultimate Music Player and Manager";
              exec = ''
                env WINEPREFIX=${cfg.winePrefix} wine "${cfg.appDir}/MusicBee.exe"
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
