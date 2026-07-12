{
  # It appears that `distrobox-host-exec` depends on host-spawn, which depends on flatpak.
  # I couldn't get it work even enabling flatpak though. Needs more testing.
  shiv.services.flatpak.nixos = {
    services.flatpak.enable = true;
  };
}
