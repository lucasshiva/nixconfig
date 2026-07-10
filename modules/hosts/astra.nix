{ shiv, ... }:
let
  username = "lucas";
  hostname = "astra";
in
{
  den.homes.x86_64-linux."${username}@${hostname}" = { };

  den.aspects.${username}.provides.${hostname} = {
    includes = with shiv; [
      core.fonts
      apps.osu
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
