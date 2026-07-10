# Installs all proprietary hardware firmware blobs (Wi-Fi, Bluetooth, Audio, etc.)
{
  shiv.hardware.all-firmware = {
    nixos.hardware.enableAllFirmware = true;
  };
}
