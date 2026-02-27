{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.nicotine-plus ];
  networking.firewall.allowedTCPPorts = [ 2234 ];
  networking.firewall.allowedUDPPorts = [
    2234
    1900 # For UPnP
  ];

  # Allow multicast for UPnP
  networking.firewall.allowPing = true;
}
