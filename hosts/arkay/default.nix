{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/services.nix
    ../common/optional/niri.nix
    ../common/optional/stylix.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix

    ./re6st.nix
  ];
  networking.hostName = "pc-louis-thevenet";
  networking.firewall.enable = lib.mkForce false;
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
}
