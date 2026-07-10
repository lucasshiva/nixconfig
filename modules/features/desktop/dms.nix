{ inputs, ... }:
{
  shiv.desktop.dms = {
    # Use DMS' polkit agent instead of niri-flake's one.
    # I'm not even sure if DMS polkit is enabled via the home-manager module. Maybe not.
    nixos.systemd.user.services.niri-flake-polkit.enable = false;

    # Use the flakes method (and home-manager module) to support standalone home-manager hosts.
    homeManager =
      { lib, config, ... }:
      let
        cfg = config.my.dms;
        dmsCfg = config.programs.dank-material-shell;

        inherit (config.lib.niri.actions) spawn;
        dms = spawn "dms" "ipc";
        bind =
          action:
          {
            overlay ? null,
            lockScreen ? false,
            ...
          }@opts:
          lib.mkForce (
            (removeAttrs opts [
              "overlay"
              "lockScreen"
            ])
            // {
              inherit action;
            }
            // lib.optionalAttrs (overlay != null) { hotkey-overlay.title = overlay; }
            // lib.optionalAttrs lockScreen { allow-when-locked = true; }
          );
      in
      {
        imports = [
          inputs.dms.homeModules.dank-material-shell
        ];

        options.my.dms = {
          enableNiriIntegration = lib.mkEnableOption "Add DMS config to Niri";
        };

        config = {
          programs.dank-material-shell = {
            enable = true;
            enableSystemMonitoring = true;
            enableVPN = true;
            enableDynamicTheming = true;
            enableClipboardPaste = true;
          };

          programs.niri.settings = lib.mkIf cfg.enableNiriIntegration {
            spawn-at-startup = lib.mkForce [
              {
                command = [
                  "dms"
                  "run"
                ];
              }
            ];

            layer-rules = [
              {
                matches = [ { namespace = "dms:blurwallpaper"; } ];
                place-within-backdrop = true;
              }
            ];

            # NOTE: maybe we could always enable shortcuts, even when Niri integration is off.
            # This would allow us to run `dms run` manually and still get all the benefits.
            # Perhaps we expose this funcionality behind an option.
            binds = {
              "Mod+Space" = bind (dms "spotlight" "toggle") {
                overlay = "Application Launcher";
              };
              "Mod+N" = bind (dms "notifications" "toggle") {
                overlay = "Notification Center";
              };
              "Mod+V" = bind (dms "clipboard" "toggle") {
                overlay = "Clipboard Manager";
              };
              "Mod+Comma" = bind (dms "settings" "focusOrToggle") {
                overlay = "Settings";
              };
              "Mod+P" = bind (dms "notepad" "toggle") {
                overlay = "Notepad";
              };
              "Mod+L" = bind (dms "lock" "lock") {
                overlay = "Lock Screen";
              };
              "Mod+X" = bind (dms "powermenu" "focusOrToggle") {
                overlay = "Power Menu";
              };
              "XF86AudioRaiseVolume" = bind (dms "audio" "increment" "3") {
                lockScreen = true;
              };
              "XF86AudioLowerVolume" = bind (dms "audio" "decrement" "3") {
                lockScreen = true;
              };
              "XF86AudioMute" = bind (dms "audio" "mute") {
                lockScreen = true;
              };
              "XF86AudioMicMute" = bind (dms "audio" "micmute") {
                lockScreen = true;
              };
              "XF86AudioPause" = bind (dms "mpris" "playPause") {
                lockScreen = true;
              };
              "XF86AudioPlay" = bind (dms "mpris" "playPause") {
                lockScreen = true;
              };
              "XF86AudioPrev" = bind (dms "mpris" "previous") {
                lockScreen = true;
              };
              "XF86AudioNext" = bind (dms "mpris" "next") {
                lockScreen = true;
              };
              "XF86MonBrightnessUp" = bind (dms "brightness" "increment" "5" "") {
                lockScreen = true;
              };
              "XF86MonBrightnessDown" = bind (dms "brightness" "decrement" "5" "") {
                lockScreen = true;
              };
              "Mod+Alt+N" = bind (dms "night" "toggle") {
                lockScreen = true;
                overlay = "Night Mode";
              };
              "Mod+Y" = bind (dms "dankdash" "wallpaper") {
                overlay = "Browse wallpapers";
              };
              "Mod+M" = lib.mkIf dmsCfg.enableSystemMonitoring (
                bind (dms "processList" "focusOrToggle") { overlay = "Task Manager"; }
              );
            };
          };
        };
      };
  };
}
