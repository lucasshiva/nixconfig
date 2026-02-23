{ config, lib, ... }:
let
  cfg = config.my.calibre;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  options.my.calibre = {
    enable = lib.mkEnableOption "Calibre";

    symlinkSettings = {
      enable = lib.mkEnableOption "Symlink calibre settings from a directory";

      path = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/commondata/Apps/Calibre/Calibre Settings";
        description = "Calibre settings directory";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.calibre.enable = true;
    home.file.".config/calibre".source = lib.mkIf cfg.symlinkSettings.enable (
      mkOutOfStoreSymlink cfg.symlinkSettings.path
    );
  };
}
