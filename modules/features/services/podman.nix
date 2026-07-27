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

    nixos = { pkgs, user, ... }: {
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

      # Seems to solve some permission issues on containers.
      users.users.${user.userName} = {
        subUidRanges = [
          {
            startUid = 100000;
            count = 65536;
          }
        ];
        subGidRanges = [
          {
            startGid = 100000;
            count = 65536;
          }
        ];
      };

    };
  };
}
