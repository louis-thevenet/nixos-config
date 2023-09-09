{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/louis
    ../optional/gnome.nix
  ];

  networking.hostName = "magnus";
  services.xserver.videoDrivers = ["nvidia"];
}
