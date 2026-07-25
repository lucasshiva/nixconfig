{ ... }:
let
  compatPath = "$HOME/.steam/steam/steamapps/compatdata";
in
{
  shiv.apps.steam = {
    nixos = { pkgs, ... }: {
      # Testing bind mounts for steam compat data path.
      # Seems to be the only way to do this globally.

      # Ensure directory exists before.
      systemd.tmpfiles.rules = [
        "d /home/lucas/.local/share/steam-compat 0755 lucas users -"
      ];

      # Bind mount. Now Steam saves things under a real EXT4 directory, even though games are on NTFS.
      # Might be good to also bind mount the shadercache directory.
      fileSystems."/mnt/test/SteamLibrary/steamapps/compatdata" = {
        device = "/home/lucas/.local/share/steam-compat";
        fsType = "none";
        options = [ "bind" ];
      };

      programs.steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
          # Try to set the var, doesn't really work.
          extraEnv = {
            STEAM_COMPAT_DATA_PATH = compatPath;
          };
          # Maybe use -env -v
          extraArgs = "--env STEAM_COMPAT_DATA_PATH=${compatPath}";
        };
      };

      programs.gamemode.enable = true;

      # Also didn't work.
      environment.sessionVariables = {
        STEAM_COMPAT_DATA_PATH = compatPath;
      };
    };
  };
}
