{ lib, ... }: {
  shiv.cli.mise = {
    homeManager.programs.mise = {
      enable = true;
      enableFishIntegration = lib.mkDefault true;
      enableBashIntegration = lib.mkDefault true;
      enableZshIntegration = lib.mkDefault true;
      enableNushellIntegration = lib.mkDefault true;
    };
  };
}
