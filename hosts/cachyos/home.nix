{ pkgs, username, ... }:
{

  imports = [
    ../../modules/git/home.nix
    ../../modules/shell/home.nix
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

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
