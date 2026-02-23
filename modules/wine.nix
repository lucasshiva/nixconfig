{ pkgs, config, ... }:
let
  baseDir = "/mnt/commondata";
  musicBeeDir = "${baseDir}/Apps/MusicBee";
  prefixDir = "${config.home.homeDirectory}/wineprefix";
in
{
  home.packages = with pkgs; [
    wineWow64Packages.stable
    winetricks

    # MusicBee
    # I've seen some guides install 'xmllite' and 'dotnet40' in the prefix as well.
    # I've got MusicBee working without those, but I'm leaving it here in case we ever need it.
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
  };
}
