{ ... }:
{
  den.aspects.boot.systemd-boot = {
    nixos =
      { ... }:
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
  };
}
