{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
  ];
  networking.hostName = "raspberrypi";
}
