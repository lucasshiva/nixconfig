{ lib, ... }:
{
  den.aspects.shell.prompts.starship = {
    homeManager.programs.starship = {
      enable = true;
      enableZshIntegration = true;
      # Currently using a modified version of the `catppuccin-powerline` preset.
      # In the future, we could also support different styles.
      settings = lib.importTOML ./starship.toml;
    };
  };
}
