{ pkgs, ... }:
{
  home.sessionVariables = {
    DOTNET_ROOT = "/usr/share/dotnet";
  };

  home.sessionPath = [
    "$HOME/.dotnet/tools"
  ];

  home.packages = [
    # Open IDEs in distrobox
    (pkgs.writeShellScriptBin "rider-arch" ''
      exec distrobox-enter arch -- rider "$@"
    '')

    (pkgs.writeShellScriptBin "code-arch" ''
      exec distrobox-enter arch -- code "$@"
    '')
  ];

  xdg.desktopEntries = {
    rider-arch = {
      name = "Rider (Arch)";
      exec = "distrobox-enter arch -- rider %u";
      icon = "rider";
      comment = ".NET IDE from JetBrains";
    };
    code-arch = {
      name = "Visual Studio Code (Arch)";
      exec = "distrobox-enter arch -- code %u";
      icon = "code";
      comment = "Text Editor";
    };
  };

  programs.distrobox = {
    enable = true;
    containers = {
      arch = {
        hostname = "arch";
        image = "archlinux:latest";
        replace = true;
        additional_packages = "uv dotnet-sdk dotnet-sdk-9.0 dotnet-targeting-pack dotnet-targeting-pack-9.0";
        exported_bins = [
          "/usr/sbin/uv"
          "/usr/sbin/dotnet"
        ];
        exported_bins_path = "~/.local/bin";
      };
    };
  };
}
