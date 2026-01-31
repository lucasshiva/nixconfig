{
  pkgs,
  ...
}:

{
  imports = [
    ./distrobox.nix
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
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/fvm/bin"
  ];

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
