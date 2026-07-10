{ ... }:
{
  shiv.cli.delta = {
    homeManager =
      { config, ... }:
      {
        programs.delta = {
          enable = true;
          enableGitIntegration = config.programs.git.enable;
          options = {
            navigate = true;
            dark = true;
            side-by-side = true;
            line-number = true;
            syntax-theme = "Catppuccin Mocha";
          };
        };
      };
  };
}
