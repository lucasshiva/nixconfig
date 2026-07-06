{ ... }:
{
  den.aspects.desktop.kde = {
    nixos =
      { pkgs, ... }:
      {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.plasma-login-manager.enable = true;

        # Exclude unwanted packages
        # environment.plasma6.excludePackages = with pkgs.kdePackages; [
        #   konsole
        # ];

        # And add missing ones.
        environment.systemPackages = with pkgs; [
          kdePackages.filelight # Visualize disk space usage.
        ];

        # Fix Dolphin file associations on non-Plasma desktop environments, like Niri.
        # See https://github.com/NixOS/nixpkgs/issues/409986
        #
        # Doesn't work for everyone.
        environment.etc."xdg/menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };
  };
}
