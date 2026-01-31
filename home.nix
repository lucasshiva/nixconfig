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

  home.sessionPath = [
    "$HOME/.local/bin"
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
  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    containers = {
      arch = {
        hostname = "arch";
        image = "archlinux:latest";
        replace = true;
        additional_packages = "uv";
        exported_bins = [
          "/usr/sbin/uv"
        ];
        exported_bins_path = "~/.local/bin";
      };
    };
  };

  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
