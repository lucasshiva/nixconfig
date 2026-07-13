{ ... }:
{
  shiv.apps.firefox = {
    # Enable default firefox system-wide.
    nixos.programs.firefox.enable = true;

    # Developer Edition only for users.
    homeManager =
      { pkgs, ... }:
      {
        # Not as common, so we use stable to avoid missing the cache on rebuilds.
        home.packages = [ pkgs.stable.firefox-devedition ];
      };
  };
}
