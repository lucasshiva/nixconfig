{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./modules/distrobox.nix
  ];

  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  xdg.enable = true;

  home.packages = with pkgs; [
    nixfmt
    nixd

    # IDEs
    jetbrains.rider
    android-studio
    jetbrains.idea

    # Utilities
    unzip
    unrar

    # Browser
    firefox-devedition

    # Media

    # Stremio requires `qtwebengine-5.15.19`, but it's insecure and building it takes too long.
    # Until we find a solution, we don't use stremio.
    # stremio

    # I sync obsidian via syncthing, so I don't need to enable it in home-manager.
    obsidian

    # Fonts
    nerd-fonts.monaspace
    inter
    merriweather

    # Osu - rhythm game
    osu-lazer-bin
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/fvm/bin"
  ];

  home.shellAliases = {
    dea = "distrobox enter arch";
    dca = "distrobox assemble create --file ~/.config/distrobox/containers.ini --replace";
    nrs = "sudo nixos-rebuild switch --flake ~/nixconfig";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.zsh = {
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
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      size = 200000;
      ignoreDups = true;
      ignoreAllDups = true;
      saveNoDups = true;
      share = true;
      extended = true;
    };
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
  };

  # `cat` clone with syntax highlighting and git integration.
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      prettybat
    ];
  };

  # A modern alternative for ls.
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    extraOptions = [
      "--header"
      "--group-directories-first"
    ];
    icons = "auto"; # This requires a nerd font.
    git = true;
    colors = "always";
  };

  # Fast text searcher. Can be used as a faster `grep` alternative.
  programs.ripgrep = {
    enable = true;
  };

  # Fuzzy finder.
  # Automatically adds Ctrl+T for file search and Ctrl+R for command history search.
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  # Syntax highlighting for git diffs.
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      dark = true;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Lucas Silva";
      user.email = "silva.lucasdev@gmail.com";
      init.defaultBranch = "main";
      merge.conflictStyle = "zdiff3"; # For `delta`.
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    settings = lib.importTOML ./modules/starship/starship.toml;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

  programs.keepassxc = {
    enable = true;
  };

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      fps_limit = [
        180
        120
        60
      ];
      toggle_fps_limit = "Shift_L+F1";
      show_fps_limit = true;
      cpu_temp = true;
      gpu_temp = true;
      vram = true;
      gamemode = true;
    };
  };

  # Symlink my osu config and files.
  home.file.".local/share/osu".source =
    config.lib.file.mkOutOfStoreSymlink "/mnt/commondata/Apps/osu";

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
