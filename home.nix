{
  config,
  pkgs,
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
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    dotDir = "${config.xdg.configHome}/zsh";
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Lucas Silva";
      user.email = "silva.lucasdev@gmail.com";
      init.defaultBranch = "main";
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

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
