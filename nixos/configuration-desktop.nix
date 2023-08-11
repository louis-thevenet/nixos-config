{ inputs, lib, config, pkgs, ... }: {
  imports = [

    ./hardware-configuration-desktop.nix
    ./common.nix
  ];


  services.xserver.videoDrivers = [ "nvidia" ];
}
