{ lib, ... }:
let
  inherit (lib) mkOption types;

  fontOptions = {
    sans = mkOption {
      type = types.listOf types.str;
      default = [ "Adwaita Sans" ];
      readOnly = true;
    };
    serif = mkOption {
      type = types.listOf types.str;
      default = [ "Adwaita Sans" ];
      readOnly = true;
    };
    emoji = mkOption {
      type = types.listOf types.str;
      default = [ "Noto Color Emoji" ];
      readOnly = true;
    };
    mono = mkOption {
      type = types.listOf types.str;
      default = [ "MonaspiceNe Nerd Font Mono" ];
      readOnly = true;
    };
  };

  fontPackages =
    pkgs: with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      adwaita-fonts
      nerd-fonts.monaspace
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.jetbrains-mono
    ];

  antialiasEnabled = true;
  hintingStyle = "slight";
  subpixelRendering = "rgb";
in
{
  shiv.core.fonts = {
    nixos =
      { pkgs, config, ... }:
      {
        options.my.fonts = fontOptions;
        config = {
          fonts.packages = (fontPackages pkgs);
          fonts.fontDir.enable = true;
          fonts.fontconfig = {
            enable = true;
            antialias = antialiasEnabled;
            hinting = {
              enable = true;
              style = hintingStyle;
            };
            subpixel.rgba = subpixelRendering;
            defaultFonts = {
              sansSerif = config.my.fonts.sans;
              serif = config.my.fonts.serif;
              emoji = config.my.fonts.emoji;
              monospace = config.my.fonts.mono;
            };
          };
        };
      };

    homeManager =
      {
        config,
        pkgs,
        isNixos,
        ...
      }:
      {
        options.my.fonts = fontOptions;

        # Only runs on standalone home-manager.
        config = lib.optionalAttrs (!isNixos) {
          home.packages = (fontPackages pkgs);
          fonts.fontconfig = {
            enable = true;
            hinting = hintingStyle;
            antialiasing = antialiasEnabled;
            subpixelRendering = subpixelRendering;
            defaultFonts = {
              sansSerif = config.my.fonts.sans;
              serif = config.my.fonts.serif;
              emoji = config.my.fonts.emoji;
              monospace = config.my.fonts.mono;
            };
          };
        };
      };
  };
}
