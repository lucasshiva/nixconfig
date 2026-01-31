{
  pkgs,
  ...
}:

{
  home.username = "lucas";
  home.homeDirectory = "/home/lucas";
  xdg.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Lucas Silva";
      user.email = "silva.lucasdev@gmail.com";
      init.defaultBranch = "main";
    };
  };

  home.packages = with pkgs; [];

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
