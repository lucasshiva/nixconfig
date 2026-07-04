{ ... }:
{
  den.aspects.desktop.kde = {
    nixos =
      { pkgs, config, ... }:
      {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.plasma-login-manager.enable = true;

        # If we want to exclude packages.
        # environment.plasma6.excludePackages = with pkgs.kdePackages; [
        #   plasma-browser-integration
        #   konsole
        #   elisa
        # ];
      };
  };
}
