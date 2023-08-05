{ config, pkgs, ... }: {

  system.stateVersion = "23.05";

  imports =
    [
      ./hardware-configuration.nix
      ./nix.nix
      ./desktop.nix
      ./bootefi.nix

    ];

  users.users.louis = {
    isNormalUser = true;
    description = "louis thevenet";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
