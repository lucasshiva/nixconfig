{
  shiv.dev.java.homeManager =
    { pkgs, ... }:
    {
      programs.java = {
        enable = true;
        package = pkgs.jdk21;
      };

      home.sessionVariables = {
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      };
    };
}
