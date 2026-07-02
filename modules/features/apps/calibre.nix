{ lib, ... }:
{
  den.aspects.apps.calibre = {
    homeManager =
      { config, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
        cfg = config.my.calibre;
      in
      {
        options.my.calibre = {
          # Settings live in a separate partition so that multiple OSes can share it.
          settingsDir = lib.mkOption {
            type = lib.types.str;
            description = "Calibre settings directory";
            default = ""; # Allows installing Calibre with default settings.
          };
        };

        config = {
          programs.calibre.enable = true;
          home.file.".config/calibre".source = lib.mkIf (cfg.settingsDir != "") (
            mkOutOfStoreSymlink cfg.settingsDir
          );
        };
      };
  };
}
