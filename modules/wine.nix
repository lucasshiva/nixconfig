{ pkgs, config, ... }:
let
  baseDir = "/mnt/commondata";
  musicBeeDir = "${baseDir}/Apps/MusicBee";
  calibreDir = "${baseDir}/Apps/Calibre Portable";
  prefixDir = "${config.home.homeDirectory}/wineprefix";
in
{
  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks

    # MusicBee
    (pkgs.writeShellScriptBin "setup-musicbee" ''
      set -e
      PREFIX="${prefixDir}/musicbee"

      if [ -e "$PREFIX/.hm-installed" ]; then
        echo "MusicBee Wine Prefix already set up."
        exit 0
      fi

      # We need to reject all dialogs about wine-mono.
      # Perhaps we could show a prompt to inform the user of that.
      export WINEPREFIX="$PREFIX"
      wineboot -u
      ln -s ${baseDir} "$PREFIX/dosdevices/f:"
      winetricks -q allfonts cjkfonts
      touch "$PREFIX/.hm-installed"

      echo "Calibre setup complete."
    '')

    # Calibre.
    # We use the portable version, so there's no need to map any drives.
    (pkgs.writeShellScriptBin "setup-calibre" ''
      set -e
      PREFIX="${prefixDir}/calibre"

      if [ -e "$PREFIX/.hm-installed" ]; then
        echo "Calibre Wine Prefix already set up."
        exit 0
      fi

      export WINEPREFIX="$PREFIX"
      wineboot -u
      winetricks -q dotnet48 gdiplus allfonts cjkfonts wmp11
      touch "$PREFIX/.hm-installed"

      echo "MusicBee setup complete."
    '')
  ];

  xdg.desktopEntries = {
    musicbee = {
      name = "MusicBee";
      icon = "${musicBeeDir}/MusicBee.png";
      comment = "The Ultimate Music Player and Manager";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      exec = ''
        env WINEPREFIX=${prefixDir}/musicbee wine "${musicBeeDir}/MusicBee.exe"
      '';
    };

    calibre = {
      name = "Calibre";
      icon = "${calibreDir}/calibre.png";
      comment = "E-book management";
      categories = [
        "Viewer"
      ];
      exec = ''
        env WINEPREFIX=${prefixDir}/calibre wine "${calibreDir}/calibre-portable.exe"
      '';
    };
  };
}
