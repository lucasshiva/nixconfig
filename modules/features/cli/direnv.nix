{ ... }: {
  den.aspects.cli.direnv = {
    homeManager = { lib, ... }: {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault true;
        enableNushellIntegration = lib.mkDefault true;
      };
    };
  };
}
