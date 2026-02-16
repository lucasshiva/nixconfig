{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    settings = lib.importTOML ./starship.toml;
  };
}
