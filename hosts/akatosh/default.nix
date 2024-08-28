{
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./sops.nix
    ../common/global
    ./user.nix

    # ../common/users/louis

    ../common/optional/stylix.nix
    ../common/optional/home-impermanence-disko.nix
    # ../common/optional/ollama.nix
    # ../common/optional/hyprland.nix
  ];
  networking.hostName = "akatosh";

  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
      # displayManager.gdm = {
      #   enable = true;
      # };
    };
  };

  # hardware.bluetooth.enable = true; # enables support for Bluetooth
  # hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  # services.udisks2.enable = true;

  # programs.steam.enable = true;
  # hardware.graphics.enable = true;
}
