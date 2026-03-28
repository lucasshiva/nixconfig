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
  ];

  my.shell = {
    bash.enable = true;
    fish.enable = true;
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
