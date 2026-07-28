{ lib, ... }:
{
  shiv.apps.osu = {
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      let
        inherit (config.lib.file) mkOutOfStoreSymlink;
        cfg = config.my.osu;
      in
      {
        options.my.osu = {
          installPackage = lib.mkOption {
            type = lib.types.bool;
            description = ''
              Whether to install osu! via home-manager.

              Non-nixos hosts using standalone home-manager might want to set this to false.
            '';
            default = true;
          };

          # TODO: test whether we can use this same folder on Windows as well.
          dataDir = lib.mkOption {
            type = lib.types.str;
            description = "osu! data directory";
            default = ""; # Empty string means install osu with default settings/data.
          };
        };

        config = {
          home.packages = lib.optionals cfg.installPackage [
            # I'd prefer osu! stable instead of lazer, but stable's support for linux isn't the best.
            pkgs.osu-lazer-bin
          ];

          assertions = lib.optional (cfg.dataDir != "") {
            assertion = builtins.pathExists cfg.dataDir;
            message = "osu.dataDir does not exist: ${cfg.dataDir}";
          };

          home.file.".local/share/osu" = {
            source = lib.mkIf (cfg.dataDir != "") (mkOutOfStoreSymlink cfg.dataDir);
            recursive = true;
          };
        };
      };
  };
}
