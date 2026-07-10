{ ... }: {
  shiv.services.syncthing = {
    homeManager =
      { config, ... }:
      let
        certPath = "home-pc/syncthing/cert";
        keyPath = "home-pc/syncthing/key";
      in
      {

        sops.secrets.${certPath} = { };
        sops.secrets.${keyPath} = { };

        services.syncthing = {
          enable = true;
          cert = config.sops.secrets.${certPath}.path;
          key = config.sops.secrets.${keyPath}.path;
          overrideFolders = false;
          overrideDevices = false;
        };
      };
  };
}
