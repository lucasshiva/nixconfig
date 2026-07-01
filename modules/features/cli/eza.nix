{ ... }:
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
      enableZshIntegration = true;
    };
  };
}
