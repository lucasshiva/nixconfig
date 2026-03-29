{ lib, ... }:

{
  options.my.osu = {
    enable = lib.mkEnableOption "osu! support";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to install osu! via home-manager";
    };
    symlinkFiles = {
      enable = lib.mkEnableOption "Symlink osu files from a shared drive";

      path = lib.mkOption {
        type = lib.types.str;
        default = "/mnt/commondata/Apps/osu";
        description = "Shared osu data directory";
      };
    };
  };
}
