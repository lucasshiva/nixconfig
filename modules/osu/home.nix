{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.osu;
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [ ./common.nix ];

  config = lib.mkIf cfg.enable {
    home.packages = lib.optionals cfg.installPackage [
      pkgs.osu-lazer-bin
    ];
    home.file.".local/share/osu".source = lib.mkIf cfg.symlinkFiles.enable (
      mkOutOfStoreSymlink cfg.symlinkFiles.path
    );
  };
}
