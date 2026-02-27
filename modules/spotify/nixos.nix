{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.spotify ];
  networking.firewall.allowedTCPPorts = [
    57621 # Local discovery
  ];
}
