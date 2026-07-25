{
  shiv.services.podman = {
    homeManager = {
      services.podman = {
        enable = true;
        settings.containers = {
          compose_warning_logs = false;
        };
      };
    };
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        docker-compose
      ];

      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
    };
  };
}
