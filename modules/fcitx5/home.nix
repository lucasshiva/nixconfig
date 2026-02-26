{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.fcitx5;
  addons =
    lib.optional cfg.languages.japanese pkgs.fcitx5-mozc
    ++ lib.optional cfg.languages.korean pkgs.fcitx5-hangul;
in
{
  options.my.fcitx5 = {
    enable = lib.mkEnableOption "Enable fcitx5 input method framework";
    languages = {
      japanese = lib.mkEnableOption "Enable Japanese input (Mozc)";
      korean = lib.mkEnableOption "Enable Korean input (Hangul)";
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = addons;
      fcitx5.waylandFrontend = true;
    };
  };
}
