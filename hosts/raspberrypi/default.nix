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

  services.openssh = {
    enable = true;
    #passwordAuthentication = false;
  };
}
