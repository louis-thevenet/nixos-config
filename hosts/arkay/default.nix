{ pkgs, ... }:
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
  ];
  networking.hostName = "pc-louis-thevenet";

  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/home/louis/cache-priv-key.pem";
  };

  networking.firewall.allowedTCPPorts = [
    5000
  ];
}
