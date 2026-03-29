{ pkgs, username, ... }:
{

  imports = [
    ../../modules/git/home.nix
    ../../modules/shell/home.nix
    ../../modules/calibre/home.nix
    ../../modules/osu/home.nix
    ../../modules/fcitx5/home.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.packages = with pkgs; [
    nixd
    nil

    # -- Font packages --
    # The fonts below are usually already installed via other means, usually during installation.
    # For example, some KDE packages require `noto-fonts` to be installed via pacman.
    #
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    #
    # Programming fonts
    nerd-fonts.monaspace
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
  ];

  my.shell = {
    bash.enable = true;
    fish.enable = true;
    addons = {
      starshipPrompt = true;
      fzf = true;
      eza = true;
      bat = true;
      ripgrep = true;
      direnv = true;
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "MonaspiceNe Nerd Font Mono"
          "JetBrainsMono Nerd Font Mono"
          "DejaVuSansM Nerd Font Mono"
          "DejaVu Sans Mono"
        ];
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        emoji = [ "Noto Emoji" ];
      };
      hinting = "slight";
      antialiasing = true;
      subpixelRendering = "rgb";
    };
  };

  # --- For Korean and Japanese inputs ---
  my.fcitx5 = {
    enable = true;
    languages = {
      japanese = true;
      korean = true;
    };
  };

  # --- osu! - rhythm game ---
  my.osu = {
    enable = true;
    # We install osu via the AUR.
    installPackage = false;
    symlinkFiles.enable = true;
  };

  # --- Calibre ebook manager ---
  my.calibre = {
    enable = true;
    symlinkSettings.enable = true;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
