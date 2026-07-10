{ lib, ... }:
{
  shiv.cli.zoxide = {
    homeManager.programs.zoxide = {
      enable = true;
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableFishIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
    };
  };
}
