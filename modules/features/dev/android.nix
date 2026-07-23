{ ... }: {
  shiv.dev.android.homeManager = { pkgs, ... }: {
    # home.packages = [ pkgs.android-studio ];
    home.sessionVariables = {
      ANDROID_HOME = "$HOME/Android/Sdk";
      ANDROID_SDK_ROOT = "$HOME/Android/Sdk";
    };

    home.sessionPath = [
      "$HOME/Android/Sdk/platform-tools"
      "$HOME/Android/Sdk/emulator"
      "$HOME/Android/Sdk/cmdline-tools/latest/bin"
    ];
  };
}
