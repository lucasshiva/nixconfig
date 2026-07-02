{ ... }:
{
  den.aspects.cli.git = {
    homeManager =
      { config, lib, ... }:
      let
        cfg = config.my.git;
      in
      {
        options.my.git = {
          user.name = lib.mkOption {
            type = lib.types.str;
            description = "User name for Git";
          };
          user.email = lib.mkOption {
            type = lib.types.str;
            description = "Email for git";
          };
        };
        config = {
          programs.git = {
            enable = true;
            settings = {
              user.name = cfg.user.name;
              user.email = cfg.user.email;
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
            };
          };
        };
      };
  };
}
