{
  shiv,
  inputs,
  lib,
  ...
}:
{
  shiv.desktop.niri = {
    includes = [ shiv.desktop.niri.binds ];

    nixos =
      { ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
        };

        # NixOS otherwise injects a stripped PATH via Environment= on the niri.service
        # unit which shadows the imported user-manager PATH. Disabling the default
        # lets niri inherit the full PATH set up by niri-session.
        systemd.user.services.niri.enableDefaultPath = false;

        # Could enable this if we're not using KDE.
        services.gnome.gnome-keyring.enable = false;

        # Maybe we don't need this since DMS/Noctalia have polkit built-in?
        security.polkit.enable = true;

        # If we're using `xdg-desktop-portal-gnome`, it will attempt to use Nautilus as the file picker,
        # which will fail if Nautilus is not installed.
        #
        # To work around this problem, you can force usage of the gtk or kde portals for file picker instead.
        xdg.portal.config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ]; # or "gtk"
        };

        programs.niri.enable = true;
      };

    homeManager =
      { pkgs, ... }:
      {
        imports = [
          inputs.niri.homeModules.niri
        ];

        options.my.niri = {
          term = lib.mkOption {
            type = lib.types.package;
            description = "Default terminal for Niri";
            default = pkgs.kitty;
          };
        };

        config = {
          # `programs.niri` comes from niri-flake.
          home.packages = with pkgs; [ xwayland-satellite ];
          programs.niri = {
            enable = true;
            package = pkgs.niri; # from nixpkgs to benefit from binary cache
            settings = {
              input.keyboard.xkb.options = "compose:rwin";

              outputs = {
                "DP-3" = {
                  mode.width = 2560;
                  mode.height = 1440;
                  position.x = 0;
                  position.y = 0;
                };
                "DP-2" = {
                  mode.width = 1920;
                  mode.height = 1080;
                  position.x = 2560; # Right to DP-3.
                  position.y = 0;
                };
                "HDMI-A-1" = {
                  scale = 1.3;
                  position.x = 2560; # Right to DP-3.
                  position.y = 1080; # Below DP-2
                };
              };

              layout = {
                gaps = 16;
                default-column-width = {
                  proportion = 0.5;
                };
                always-center-single-column = true;
                border.width = 2;
                focus-ring.width = 2;
              };

              window-rules = [
                {
                  geometry-corner-radius =
                    let
                      r = 16.0;
                    in
                    {
                      top-left = r;
                      top-right = r;
                      bottom-left = r;
                      bottom-right = r;
                    };
                  clip-to-geometry = true;
                  tiled-state = true;
                  draw-border-with-background = false;
                }
              ];
            };
          };
        };
      };
  };
}
