{ config, ... }:
let
  syncPath = "/mnt/commondata/Sync";
  phonePath = "${syncPath}/POCO X7 Pro";
in
{

  # Saving the key and cert files allow us to automatically connect to our devices.
  # NOTE: This still needs more testing.
  # See https://wiki.nixos.org/wiki/Syncthing#Declarative_node_IDs
  sops.secrets."syncthing/key" = {
    owner = "lucas";
  };
  sops.secrets."syncthing/cert" = {
    owner = "lucas";
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "lucas";
    dataDir = "/home/lucas";
    key = config.sops.secrets."syncthing/key".path;
    cert = config.sops.secrets."syncthing/cert".path;
    overrideDevices = true;
    settings.devices = {
      "Phone" = {
        id = "ARDTWJM-7LRLGSJ-XVK2RLJ-3673OXN-5M55L4Y-KBIK2JK-P6JOSSA-2MY7LQB";
      };
    };
    settings.folders = {
      "Poco X7 Pro - DCIM" = {
        id = "gmfti-xfrta";
        path = "${phonePath}/DCIM";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - Documents" = {
        id = "ufkpo-s5isq";
        path = "${phonePath}/Documents";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - Download" = {
        id = "hds9i-wgwpt";
        path = "${phonePath}/Download";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - Komikku" = {
        id = "haoh6-2uxsz";
        path = "${phonePath}/Komikku";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - Pictures" = {
        id = "kffam-ydqma";
        path = "${phonePath}/Pictures";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - ReadEra" = {
        id = "tkxr9-s5am9";
        path = "${phonePath}/ReadEra";
        devices = [ "Phone" ];
      };
      "Poco X7 Pro - Videos" = {
        id = "i1wsr-gbgs3";
        path = "${phonePath}/Videos";
        devices = [ "Phone" ];
      };
      "Shared - Books" = {
        id = "nsqwe-2ufpw";
        path = "${syncPath}/Books";
        devices = [ "Phone" ];
      };
      "Shared - Data" = {
        id = "xddpm-dsw2w";
        path = "${syncPath}/Data";
        devices = [ "Phone" ];
      };
      "Shared - Documents" = {
        id = "duzzw-vapnh";
        path = "${syncPath}/Documents";
        devices = [ "Phone" ];
      };
      "Shared - Gifs" = {
        id = "9bjle-uxa54";
        path = "${syncPath}/Media/Gifs";
        devices = [ "Phone" ];
      };
      "Shared - Phone Music" = {
        id = "wwvms-awi5v";
        path = "${syncPath}/Media/Music";
        devices = [ "Phone" ];
      };
      "Shared - Pictures" = {
        id = "pis3e-zkpuc";
        path = "${syncPath}/Media/Pictures";
        devices = [ "Phone" ];
      };
      "Shared - Videos" = {
        id = "xrhwv-fjjbt";
        path = "${syncPath}/Media/Videos";
        devices = [ "Phone" ];
      };
    };
  };
}
