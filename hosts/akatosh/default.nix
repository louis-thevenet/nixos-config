{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/services.nix
    ../common/optional/stylix.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/ollama.nix
    ../common/optional/niri.nix
    ../common/optional/tlp.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/virt.nix
  ];
  networking.hostName = "akatosh";
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/home/louis/cache-priv-key.pem";
  };

  networking.firewall.allowedTCPPorts = [
    5000
  ];
  services = {
    udisks2.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  programs.steam.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
}
