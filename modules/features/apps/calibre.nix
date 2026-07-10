{ lib, ... }:
{
  shiv.apps.calibre = {
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
            description = ''
              The directory where Calibre Settings is stored.

              If the Library path is unchanged, Calibre will work without additional configuration.
              Otherwise, we will be prompted to select a library on startup. This happens only once.

              Technically, it is possible to set the Library path by updating the `global.py.json`
              file, but I don't mind selecting it manually on startup on the first run.
            '';
            default = ""; # Allows installing Calibre with default settings.
            example = "/mnt/shared/Calibre/Calibre Settings";
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
