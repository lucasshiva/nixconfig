{
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
    stremio

    # I sync obsidian via syncthing, so I don't need to enable it in home-manager.
    obsidian
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

  programs.bash.enable = true;

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

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
