{ ... }:
{
  den.aspects.desktop.gnome = {
    nixos =
      { pkgs, ... }:
      {
        # Enable GNOME and GDM.
        services.displayManager.gdm.enable = true;
        services.desktopManager.gnome.enable = true;

        # Exclude some packages by default.
        services.gnome.games.enable = false;
        environment.gnome.excludePackages = with pkgs; [
          gnome-tour
          gnome-user-docs
        ];
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ gnome-tweaks ];
      };
  };
}
