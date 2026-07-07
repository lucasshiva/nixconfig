{ lib, ... }:
{
  den.aspects.cli.fzf = {
    homeManager.programs.fzf = {
      enable = true;
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
    };
  };
}
