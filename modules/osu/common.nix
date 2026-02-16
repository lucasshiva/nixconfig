{ lib, ... }:

{
  options.my.osu = {
    enable = lib.mkEnableOption "osu! support";

    symlinkFiles = {
      enable = lib.mkEnableOption "Symlink osu files from a shared drive";

      path = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/commondata/Apps/osu";
        description = "Shared osu data directory";
      };
    };

    enableTablet = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tablet support automatically";
    };
  };
}
