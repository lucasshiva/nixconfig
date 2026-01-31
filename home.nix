{
  pkgs,
  ...
}:

{
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  xdg.enable = true;

  home.packages = with pkgs; [
    nixfmt
    nixd
  ];

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
    package = pkgs.vscode.fhs;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
