{ lib, ... }:
{
  den.aspects.apps.firefox = {
    homeManager =
      { config, pkgs, ... }:
      let
        inherit (config.lib.file) mkOutOfStoreSymlink;
        cfg = config.my.firefox;
      in
      {
        options.my.firefox = {
          installPackages = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to install firefox packages via home-manager";
            default = true;
          };
          baseDirectory = lib.mkOption {
            type = lib.types.str;
            description = "Directory containing the profiles.";
            default = "/mnt/commondata/Apps/Firefox";
          };
          profiles = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Name of the profiles to expose locally.";
            default = [
              "stable-profile"
              "dev-profile"
            ];
          };
        };

        config = {
          home.packages = lib.optionals cfg.installPackages [
            pkgs.firefox-bin
            pkgs.firefox-devedition
          ];

          home.file = lib.listToAttrs (
            map (profileName: {
              name = ".config/mozilla/firefox/${profileName}";
              value.source = mkOutOfStoreSymlink "${cfg.baseDirectory}/${profileName}";
            }) cfg.profiles
          );
        };
      };
  };
}
