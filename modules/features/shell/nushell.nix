{ ... }: {
  shiv.shell.nushell = {
    homeManager = { ... }: {
      programs.nushell = {
        enable = true;
        # settings = {
        #   show_banner = false;
        #   completions = {
        #     case_sensitive = false;
        #     quick = true;
        #     partial = true;
        #     algorithm = "fuzzy";
        #   };
        #   history = {
        #     max_size = 100000;
        #     sync_on_enter = true;
        #     file_format = "sqlite";
        #   };
        # };
      };
    };
  };
}
