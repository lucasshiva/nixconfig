{ shiv, ... }:
{
  shiv.desktop.kde = {
    includes = [ shiv.apps.kitty ];
    nixos =
      { pkgs, ... }:
      {
        services.desktopManager.plasma6.enable = true;
        services.displayManager.plasma-login-manager.enable = true;

        # Exclude unwanted packages
        environment.plasma6.excludePackages = with pkgs.kdePackages; [
          konsole
          gwenview
        ];

        # And add missing ones.
        environment.systemPackages = with pkgs; [
          kdePackages.filelight # Visualize disk space usage.s
          ffmpegthumbnailer # video thumbnailer.
          kdePackages.merkuro # Calendar, contacts, emails
          qimgv # Super fast image viewer
          haruna # Video player
        ];

        # Fix Dolphin file associations on non-Plasma desktop environments, like Niri.
        # See https://github.com/NixOS/nixpkgs/issues/409986
        #
        # Setting `XDG_MENU_PREFIX = "plasma-"` in WM (niri, hyprland, etc.) config also helps.
        environment.etc."xdg/menus/applications.menu".source =
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      };
  };
}
