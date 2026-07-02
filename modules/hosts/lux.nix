{ den, ... }:
let
  username = "lucas";
  hostname = "lux";
in
{
  den.homes.x86_64-linux."${username}@${hostname}" = { };

  den.aspects.${username}.provides.${hostname} = {
    includes = with den; [
      aspects.core.fonts
      aspects.desktop.gnome
    ];

    homeManager =
      { ... }:
      {
        # Install the home-manager CLI.
        programs.home-manager.enable = true;
      };
  };
}
