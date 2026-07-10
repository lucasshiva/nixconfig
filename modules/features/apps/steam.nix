{ ... }: {
  shiv.apps.steam = {
    nixos = { ... }: {
      programs.steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
      };

      programs.gamemode.enable = true;
    };
  };
}
