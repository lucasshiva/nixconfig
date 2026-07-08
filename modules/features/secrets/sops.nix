{ inputs, ... }: {
  den.aspects.secrets.sops.homeManager = { pkgs, config, ... }: {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];

    home.packages = with pkgs; [
      sops
      age
      ssh-to-age
    ];

    sops = {
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      age.sshKeyPaths = [ ];
      age.generateKey = false;
      defaultSopsFile = ./secrets.yaml;
      validateSopsFiles = true;
    };
  };
}
