{
  lib,
  config,
  pkgs,
  username,
  inputs,
  ...
}:

{
  imports = [
    inputs.niri.homeModules.niri
    inputs.noctalia.homeModules.default

    ../../modules/distrobox.nix
    ../../modules/wine.nix
    ../../modules/starship
    ../../modules/osu/home.nix
    ../../modules/calibre/home.nix
    ../../modules/fcitx5/home.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  xdg.enable = true;

  home.packages =
    with pkgs;
    [
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
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # Spotdl
      ffmpeg
      spotdl
      yt-dlp

      # Build essentials
      gcc
      gnumake
      binutils
      pkg-config
      openssl
      zlib
      bzip2
      xz
      readline
      libffi

      # dev shells
      devenv

      # Application/browser chooser
      junction

      # To decompile Terraria and tModLoader
      powershell
      ilspycmd

      killall
    ]
    ++ lib.optionals config.programs.noctalia-shell.enable [
      # Niri automatically runs this when xwayland support is required
      (xwayland-satellite.override { withSystemd = false; })
    ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "x-scheme-handler/http" = "re.sonny.Junction.desktop";
      "x-scheme-handler/https" = "re.sonny.Junction.desktop";
      "text/html" = "re.sonny.Junction.desktop";
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
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
    completionInit = ''
      autoload -Uz compinit
      compinit -u
    '';
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

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.anki = {
    enable = true;
  };

  my.osu = {
    enable = true;
    symlinkFiles.enable = true;
  };

  my.calibre.enable = true;
  my.calibre.symlinkSettings.enable = true;

  my.fcitx5 = {
    enable = true;
    languages = {
      japanese = true;
      korean = true;
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
    config = ''
      layout {
        gaps 16
      }

      window-rule {
        // Rounded corners for a modern look.
        geometry-corner-radius 20

        // Clips window contents to the rounded corner boundaries.
        clip-to-geometry true
      }

      debug {
        // Allows notification actions and window activation from Noctalia.
        honor-xdg-activation-with-invalid-serial
      }

      binds {
        Mod+T hotkey-overlay-title="Open a Terminal: konsole" { spawn "konsole"; }
        Mod+F { maximize-column; }
        Mod+Q repeat=false { close-window; }
        Mod+O repeat=false { toggle-overview; }
        Mod+Shift+E { quit; }
      }
    ''
    + lib.optionalString config.programs.noctalia-shell.enable ''

      spawn-at-startup "noctalia-shell"

      layer-rule {
        match namespace="^noctalia-overview*"
        place-within-backdrop true
      }
    '';
  };

  programs.noctalia-shell = {
    enable = true;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
