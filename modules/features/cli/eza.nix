{ lib, ... }:
{
  den.aspects.cli.eza = {
    homeManager.programs.eza = {
      enable = true;
      extraOptions = [
        "--long"
        "--all"
        "--header"
        "--group-directories-first"
      ];
      icons = "auto";
      git = true;
      colors = "always";
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
    };
  };
}
