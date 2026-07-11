{ shiv, ... }: {
  shiv.services.syncthing = {
    includes = [ shiv.secrets.sops ];

    homeManager =
      { config, ... }:
      let
        certPath = "home-pc/syncthing/cert";
        keyPath = "home-pc/syncthing/key";

        # I've been repeating this a lot, so maybe we can move this to `den.schema`, making it
        # available for both users and hosts.
        dataDrive = "/mnt/data";

        # Essentially maps to my phone's internal storage.
        phonePath = "${dataDrive}/Devices/POCO X7 Pro";

        # The PC only connects to the phone.
        devices = [ "phone" ];
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
          settings = {
            devices = {
              phone = {
                id = "YJTULDM-BE27YPD-NFOGIAP-6ZV6SJL-4NJTGYR-NLGZBI6-TELCQA2-LCXVKQM";
                name = "Poco X7 Pro";
              };
            };

            # The home-manager module doesn't support folder grouping yet, so we do it manually
            # in the Web UI.
            folders = {
              "Aegis" = {
                inherit devices;
                id = "aegis";
                path = "${dataDrive}/Apps/Aegis";
                versioning.type = "trashcan";
              };
              "KeePassXC" = {
                inherit devices;
                id = "keepassxc";
                path = "${dataDrive}/Apps/KeePass";
                versioning.type = "trashcan";
              };
              "Obsidian" = {
                inherit devices;
                id = "obsidian";
                path = "${dataDrive}/Apps/Obsidian";
                versioning.type = "trashcan";
              };
              "Komikku" = {
                inherit devices;
                id = "phone-komikku";
                path = "${phonePath}/Komikku";
                versioning.type = "trashcan";
              };
              "ReadEra" = {
                inherit devices;
                id = "phone-readera";
                path = "${phonePath}/ReadEra";
                versioning.type = "trashcan";
              };
              "Documents" = {
                inherit devices;
                id = "documents";
                path = "${dataDrive}/Documents";
                versioning.type = "trashcan";
              };
              "Books" = {
                inherit devices;
                id = "books";
                path = "${dataDrive}/Books";
                versioning.type = "trashcan";
              };
              "Gifs" = {
                inherit devices;
                id = "media-gifs";
                path = "${dataDrive}/Media/Gifs";
                versioning.type = "trashcan";
              };
              "Pictures" = {
                inherit devices;
                id = "media-pictures";
                path = "${dataDrive}/Media/Pictures";
                versioning.type = "trashcan";
              };
              "Videos" = {
                inherit devices;
                id = "media-videos";
                path = "${dataDrive}/Media/Videos";
                versioning.type = "trashcan";
              };
              "DCIM" = {
                inherit devices;
                id = "phone-dcim";
                path = "${phonePath}/DCIM";
                versioning.type = "trashcan";
              };
              "Phone-Documents" = {
                inherit devices;
                id = "phone-documents";
                label = "Documents";
                path = "${phonePath}/Documents";
                versioning.type = "trashcan";
              };
              "Download" = {
                inherit devices;
                id = "phone-downloads";
                path = "${phonePath}/Download";
                versioning.type = "trashcan";
              };
              "PhoneVideos" = {
                inherit devices;
                id = "phone-videos";
                label = "Videos";
                path = "${phonePath}/Videos";
                versioning.type = "trashcan";
              };
              "Phone-Pictures" = {
                inherit devices;
                id = "phone-pictures";
                label = "Pictures";
                path = "${phonePath}/Pictures";
                versioning.type = "trashcan";
              };
            };
          };
        };
      };
  };
}
