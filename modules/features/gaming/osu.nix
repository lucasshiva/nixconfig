{ lib, ... }:
{
  den.aspects.gaming.osu = {
    homeManager =
      {
        config,
        pkgs,
        isNixos,
        ...
      }:
      let
        cfg = config.my.osu;
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        options.my.osu = {
          installPackage = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to install osu! via home-manager on standalone hosts";
            default = true;
          };
          dataDir = lib.mkOption {
            type = lib.types.str;
            description = "osu! data directory - usually shared between systems/pcs";
            default = "";
          };
        };

        config = {
          home.packages = lib.optionals cfg.installPackage [
            pkgs.osu-lazer-bin
          ];

          home.file.".local/share/osu".source = lib.mkIf (cfg.dataDir != "") (
            mkOutOfStoreSymlink cfg.dataDir
          );
        };
      };
  };
}
