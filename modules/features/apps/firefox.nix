{ ... }:
{
  den.aspects.apps.firefox = {
    # Enable default firefox system-wide.
    nixos.programs.firefox.enable = true;

    # Developer Edition only for users.
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.firefox-devedition ];
      };
  };
}
