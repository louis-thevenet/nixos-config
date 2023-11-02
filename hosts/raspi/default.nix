{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/louis
  ];

  networking.hostName = "raspi";
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
  };
}
