{ pkgs, ... }:
{
  # WiVRn manages OpenXR and OpenVR runtimes when the Quest 2 connects.
  # The package includes xrizer for OpenVR games; SteamVR is not needed.
  services.wivrn = {
    enable = true;
    openFirewall = true;
    steam.importOXRRuntimes = true;
  };

  # Install the matching WiVRn client APK on the headset over USB if needed.
  environment.systemPackages = [ pkgs.android-tools ];
}
