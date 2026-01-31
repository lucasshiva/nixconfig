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
        additional_packages = [
          # Build tools
          "base-devel"
          "which"
          "clang"
          "cmake"
          "ninja"
          "pkgconf"
          "gtk3"
          "mesa-utils"

          # Dev tools
          "uv"
          "bun"
          "dotnet-sdk"
          "dotnet-sdk-9.0"
          "dotnet-targeting-pack"
          "dotnet-targeting-pack-9.0"
          "aspnet-runtime"
          "aspnet-targeting-pack"
        ];
        exported_bins = [
          "/usr/sbin/uv"
          "/usr/sbin/dotnet"
          "/usr/sbin/bun"
          "/home/lucas/fvm/bin/fvm"
        ];
        exported_bins_path = "~/.local/bin";
        pre_init_hooks = [
          "curl -fsSL https://fvm.app/install.sh | bash"
        ];
      };
    };
  };
}
