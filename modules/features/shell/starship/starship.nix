{ lib, ... }:
{
  shiv.shell.prompts.starship = {
    homeManager =
      { config, ... }:
      let
        cfg = config.my.starship;
        catppuccin-minimal = lib.importTOML ./catppuccin-minimal.toml;
        catppuccin-powerline = lib.importTOML ./catppuccin-powerline.toml;
      in
      {

        options.my.starship = {
          theme = lib.mkOption {
            type = lib.types.enum [
              "catppuccin-minimal"
              "catppuccin-powerline"
            ];
            default = "catppuccin-minimal";
            description = "Prompt theme";
          };
        };

        config = {
          programs.starship = {
            enable = true;
            enableBashIntegration = lib.mkDefault true;
            enableZshIntegration = lib.mkDefault true;
            enableFishIntegration = lib.mkDefault true;
            enableNushellIntegration = lib.mkDefault true;
            settings = if cfg.theme == "catppuccin-minimal" then catppuccin-minimal else catppuccin-powerline;
          };
        };
      };
  };
}
