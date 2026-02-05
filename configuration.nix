# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/syncthing.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lucas = {
    isNormalUser = true;
    description = "Lucas";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Enable it here to set as default, but configuration is done via home-manager.
  programs.zsh.enable = true;

  # Internet
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "pt_BR.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ALL = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opentabletdriver.enable = true;

  # Required by OpenTabletDriver
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    # With this, mangohud's vulkan layers are installed into /run/opengl-driver
    # and will be loaded by default for every vulkan app, Steam or not.
    # See https://www.reddit.com/r/NixOS/comments/11d76bb/comment/jaqzwyt
    extraPackages = with pkgs; [ mangohud ];
    extraPackages32 = with pkgs; [ mangohud ];
  };

  hardware.nvidia.open = true;
  hardware.nvidia.nvidiaSettings = true;

  # Should help with sleep/hibernate problems.
  hardware.nvidia.powerManagement.enable = true;

  # For Wayland, is highly recommended to enable kernel mode settings (KMS).
  hardware.nvidia.modesetting.enable = true;

  # Also enables `steam-hardware` for Steam Controller or Valve Index.
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  # For improved gaming performance
  programs.gamemode = {
    enable = true;
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [
    # For my EPSON L3250.
    epson-escpr2

    # Additional drivers in case I need it.
    gutenprint # Many inkjets
    hplip # HP
    splix # Samsung
  ];

  # Automatical discovery of network printers via mDNS / IPP.
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # For Flutter Web. Might migrate to Helium later on.
  programs.chromium.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    neovim
    ntfs3g

    # Steam
    steam-run # run commands in the same steam FHS environment.
    protonup-qt # Manage proton versions

    # Disk benchmark tool. Must be installed system-wide.
    kdiskmark

    # Disk space visualizer
    kdePackages.filelight

    # Utilities
    usbutils
    pavucontrol

    # Secrets
    age
    sops
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    ANDROID_HOME = "$HOME/Android/Sdk"; # SDK is installed via Android Studio
    CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Exposes Nix profile to Distrobox containers.
  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
  '';

  # Helps running prebuilt binaries.
  # This is necessary to run `python` from a venv in `pkgs.vscode`.
  programs.nix-ld = {
    enable = true;

    # Include libraries from steam by default.
    # Add other libraries as needed. See https://wiki.nixos.org/wiki/Nix-ld
    libraries = [
      (pkgs.runCommand "steamrun-lib" { } "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
    ];
  };

  zramSwap.enable = true;

  # Secrets management
  sops.defaultSopsFile = ./secrets/secrets.yaml;

  # Save/backup file. I'm using KeePassXC for that.
  sops.age.keyFile = "/home/lucas/.config/sops/age/keys.txt";
  sops.age.generateKey = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  home-manager.backupFileExtension = "bak";
}
