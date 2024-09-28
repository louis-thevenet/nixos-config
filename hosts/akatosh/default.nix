{
  lib,
  config,
  nixos-hardware,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/stylix.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/ollama.nix
    ../common/optional/hyprland.nix
    ../common/optional/tlp.nix
  ];
  networking.hostName = "akatosh";

  services.asusd = {
    enable = true;
    enableUserService = true;
    # asusdConfig = ''
    #   "bat_charge_limit": 80,
    # '';
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  programs.steam.enable = true;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.udisks2.enable = true;
  hardware.graphics.enable = true;
}
