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
  ];

  home.shellAliases = {
    dea = "distrobox enter arch";
    dca = "distrobox assemble create --file ~/.config/distrobox/containers.ini --replace";
  };

  xdg.desktopEntries = {
    rider-arch = {
      name = "Rider (Arch)";
      exec = "distrobox-enter arch -- rider %u";
      icon = "rider";
      comment = ".NET IDE from JetBrains";
    };

    idea-arch = {
      name = "Intellij IDEA (Arch)";
      exec = "distrobox-enter arch -- idea %u";
      icon = "idea";
      comment = "Java, Kotlin, Groovy, and Scala IDE from JetBrains";
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

          # Dotnet
          "dotnet-sdk"
          "dotnet-sdk-9.0"
          "dotnet-targeting-pack"
          "dotnet-targeting-pack-9.0"
          "aspnet-runtime"
          "aspnet-targeting-pack"

          # Java
          "jdk-openjdk"
          "jdk21-openjdk"
          "jdk17-openjdk"
        ];
        exported_bins = [
          "/usr/sbin/uv"
          "/usr/sbin/dotnet"
          "/usr/sbin/bun"
          "/usr/sbin/java"
          "/usr/sbin/javac"
          "/home/lucas/fvm/bin/fvm"
        ];
        exported_bins_path = "~/.local/bin";
        pre_init_hooks = [
          "curl -fsSL https://fvm.app/install.sh | bash"
        ];
        init_hooks = [
          "archlinux-java set java-25-openjdk"
        ];
      };
    };
  };
}
