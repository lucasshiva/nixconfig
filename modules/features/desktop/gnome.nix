{ lib, ... }:
{
  shiv.desktop.gnome = {
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
      { pkgs, config, ... }:
      let
        fontCfg = config.my.fonts;
        setGnomeFont =
          fontList: size: lib.mkIf (fontList != [ ]) "${builtins.head fontList} ${toString size}";
      in
      {
        home.packages = with pkgs; [
          gnome-tweaks
          dconf-editor
        ];

        dconf.enable = true;
        dconf.settings = with lib.gvariant; {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            font-name = setGnomeFont fontCfg.sans 12;
            document-font-name = setGnomeFont fontCfg.serif 12;
            monospace-font-name = setGnomeFont fontCfg.mono 11;
            enable-hot-corners = false;
          };
          "org/gnome/desktop/input-sources" = {
            xkb-options = [ "compose:rwin" ];
            # Remove default 'us' layout
            mru-sources = [
              (mkTuple [
                "xkb"
                "us"
              ])
            ];
            # Add 'altgr-intl' layout.
            sources = [
              (mkTuple [
                "xkb"
                "us+altgr-intl"
              ])
            ];
          };
          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
          };
          "org/gnome/desktop/session" = {
            idle-delay = (mkUint32 0); # Disable screen lock.
          };
          "org/gnome/shell" = {
            always-show-log-out = true;
          };
          "org/gnome/mutter" = {
            center-new-windows = true;
          };
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
          };
        };
      };
  };
}
