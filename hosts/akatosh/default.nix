_: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./howdy.nix
    ../common/global
    ../common/optional/services.nix
    ../common/optional/impermanence-disko.nix
    ../common/optional/niri.nix
    ../common/optional/tlp.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/stylix.nix
  ];
  networking.hostName = "akatosh";
  networking.firewall.allowedTCPPorts = [
    5000
  ];
  programs.steam.enable = true;
  programs.gamescope.enable = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
  services = {
    udisks2.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}
