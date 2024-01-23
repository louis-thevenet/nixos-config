{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #./hardware-configuration.nix
    ../common/global
    ../common/users/louis
  ];

  users.users.louis.initialPassword = "root";
  networking = {
    hostName = "rasberrypi";
    useDHCP = false;
    interfaces = {wlan0.useDHCP = true;};
  };

  services = {
    xserver = {
      enable = true;
      layout = "fr";
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
      };
    };
  };
  services.openssh = {
    enable = true;
    #passwordAuthentication = false;
  };
}
