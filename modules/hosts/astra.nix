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

        # Putting this under `den.default.homeManager` on NixOS gives me a warning, so we make this
        # opt-in instead.
        nixpkgs.config.allowUnfree = true;

        my.osu = {
          installPackage = false;
          dataDir = "/mnt/data/Apps/osu";
        };
      };
  };
}
