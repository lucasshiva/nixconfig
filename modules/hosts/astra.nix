{ den, ... }:
let
  username = "lucas";
  hostname = "astra";
in
{
  den.homes.x86_64-linux."${username}@${hostname}" = { };

  den.aspects.${username}.provides.${hostname} = {
    includes = with den; [
      aspects.core.fonts

      aspects.desktop.niri
      aspects.desktop.dms

      aspects.gaming.osu
      aspects.apps.firefox
    ];

    homeManager =
      { ... }:
      {
        # Install the home-manager CLI.
        programs.home-manager.enable = true;

        my.firefox.installPackages = false;
        my.osu = {
          installPackage = false;
          dataDir = "/mnt/commondata/Apps/osu";
        };
        my.dms.enableNiriIntegration = true;
      };
  };
}
