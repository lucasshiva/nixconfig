{ ... }: {
  den.aspects.services.syncthing = {
    homeManager = { ... }: {
      services.syncthing = {
        enable = true;
        overrideFolders = false;
        overrideDevices = false;
      };
    };
  };
}
