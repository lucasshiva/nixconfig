{ ... }: {
  den.aspects.cli.direnv = {
    homeManager = { lib, config, ... }: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        mise.enable = lib.mkDefault config.programs.mise.enable;
        enableBashIntegration = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault true;
        enableNushellIntegration = lib.mkDefault true;
      };
    };
  };
}
