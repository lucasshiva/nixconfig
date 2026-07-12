{ lib, ... }:
{
  shiv.shell.prompts.starship = {
    homeManager =
      { config, ... }:
      {

        config = {
          programs.starship = {
            enable = true;
            enableBashIntegration = lib.mkDefault true;
            enableZshIntegration = lib.mkDefault true;
            enableFishIntegration = lib.mkDefault true;
            enableNushellIntegration = lib.mkDefault true;
            settings = {
              shell = {
                bash_indicator = "bash";
                fish_indicator = "fish";
                disabled = false;
              };
              directory = {
                truncation_length = 0;
                truncate_to_repo = true;
                truncation_symbol = "…/";
                disabled = false;
              };
              # Can be useful sometimes.
              # username = {
              #   show_always = true;
              #   format = "[$user]($style)";
              # };
              # hostname = {
              #   ssh_only = false;
              #   format = "@[$hostname ]($style)";
              # };
            };
          };
        };
      };
  };
}
