{ lib, ... }:
{
  shiv.shell.zsh = {
    homeManager =
      { config, pkgs, ... }:
      {
        programs.zsh = {
          enable = true;
          plugins = [
            # Other plugins
          ]
          ++ lib.optionals config.programs.fzf.enable [
            {
              name = "fzf-tab";
              src = pkgs.zsh-fzf-tab;
              file = "share/fzf-tab/fzf-tab.plugin.zsh";
            }
          ];
          autosuggestion.enable = true;
          enableCompletion = true;
          syntaxHighlighting.enable = true;
          dotDir = "${config.xdg.configHome}/zsh";
          history = {
            size = 500000;
            ignoreDups = true;
            ignoreAllDups = true;
            saveNoDups = true;
            share = true;
            extended = true;
          };
          completionInit = ''
            autoload -Uz compinit
            compinit -u
          '';
        };
      };
  };
}
