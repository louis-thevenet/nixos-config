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

  networking.hostName = "magnus";
  services.xserver.videoDrivers = ["nvidia"];
}
