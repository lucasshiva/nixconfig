{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.shell;
in
{
  options.my.shell = {
    bash.enable = lib.mkEnableOption "Enable Bash shell";
    zsh.enable = lib.mkEnableOption "Enable ZSH";
    fish.enable = lib.mkEnableOption "Enable Fish shell";
    nushell.enable = lib.mkEnableOption "Enable NuShell";
    addons = {
      direnv = lib.mkEnableOption "Enable Direnv";
      starshipPrompt = lib.mkEnableOption "Enable Starship prompt" // {
        default = true;
      };
      fzf = lib.mkEnableOption "Enable FZF - a command-line fuzzy finder" // {
        default = true;
      };
      eza = lib.mkEnableOption "Enable Eza - a modern alternative for ls" // {
        default = true;
      };
      bat = lib.mkEnableOption "Enable Bat - a cat clone with syntax highlighting" // {
        default = true;
      };
      ripgrep = lib.mkEnableOption "Enable Ripgrep - a line-oriented search tool" // {
        default = true;
      };
    };
  };
  config = {
    programs.bash = lib.mkIf cfg.bash.enable {
      enable = true;
      enableCompletion = true;
    };

    programs.zsh = lib.mkIf cfg.zsh.enable {
      enable = true;
      plugins = [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
      autosuggestion = {
        enable = true;
        strategy = [ ];
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      history = {
        size = 200000;
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
    programs.fish = lib.mkIf cfg.fish.enable {
      enable = true;
    };
    programs.nushell = lib.mkIf cfg.nushell.enable {
      enable = true;
      settings = {
        show_banner = false;
      };
    };

    programs.starship = lib.mkIf cfg.addons.starshipPrompt {
      enable = true;
      enableZshIntegration = cfg.zsh.enable;
      enableFishIntegration = cfg.fish.enable;
      enableBashIntegration = cfg.bash.enable;
      enableNushellIntegration = cfg.nushell.enable;
      settings = lib.importTOML ./starship.toml;
    };

    # `cat` clone with syntax highlighting and git integration.
    programs.bat = lib.mkIf cfg.addons.bat {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        prettybat
      ];
    };

    # A modern alternative for ls.
    programs.eza = lib.mkIf cfg.addons.eza {
      enable = true;
      enableBashIntegration = cfg.bash.enable;
      enableZshIntegration = cfg.zsh.enable;
      enableFishIntegration = cfg.fish.enable;
      enableNushellIntegration = cfg.nushell.enable;
      extraOptions = [
        "--header"
        "--group-directories-first"
      ];
      icons = "auto"; # This requires a nerd font.
      git = true;
      colors = "always";
    };

    # Fast text searcher. Can be used as a faster `grep` alternative.
    programs.ripgrep = lib.mkIf cfg.addons.ripgrep {
      enable = true;
    };

    # Fuzzy finder.
    # Automatically adds Ctrl+T for file search and Ctrl+R for command history search.
    programs.fzf = lib.mkIf cfg.addons.fzf {
      enable = true;
      enableZshIntegration = cfg.zsh.enable;
      enableBashIntegration = cfg.bash.enable;
      enableFishIntegration = cfg.fish.enable;
    };

    programs.direnv = lib.mkIf cfg.addons.direnv {
      enable = true;
      enableZshIntegration = cfg.zsh.enable;
      enableBashIntegration = cfg.bash.enable;
      enableFishIntegration = cfg.fish.enable;
      enableNushellIntegration = cfg.nushell.enable;
    };
  };
}
