{ ... }: {
  den.aspects.cli.devenv = {
    homeManager = { lib, ... }: {
      programs.devenv = {
        enable = true;
        enableBashIntegration = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault true;
        enableNushellIntegration = lib.mkDefault true;
      };
    };
  };
}
