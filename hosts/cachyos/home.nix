{ pkgs, username, ... }:
{

  imports = [
    ../../modules/git/home.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.packages = with pkgs; [
    nixd
    nil
  ];
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
