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
      aspects.gaming.osu
    ];

    homeManager =
      { ... }:
      {
        # Install the home-manager CLI.
        programs.home-manager.enable = true;

        my.osu = {
          installPackage = false;
          dataDir = "/mnt/data/Apps/osu";
        };
      };
  };
}
