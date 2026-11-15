{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./gamma.nix
    ./sops.nix
    ./vr.nix
    ../common/global
    ../common/optional/services.nix
    ../common/optional/stylix.nix
    ../common/optional/niri.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/nix-index.nix
  ];
  networking.hostName = "magnus";
  networking.firewall.allowedTCPPorts = [ 25565 ]; # Minecraft
  networking.hosts = {
    "192.168.1.183" = [
      "db.ltvnt.com"
      "nc.ltvnt.com"
      "jellyfin.ltvnt.com"
      "ai.ltvnt.com"
      "matrix.ltvnt.com"
    ];
  };
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    # mount iphone storage with `ifuse ./mnt/iphone`
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    fuse
  ];

  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services = {
    udisks2.enable = true;
    xserver.videoDrivers = [ "amdgpu" ];
  };
  programs.steam.enable = true;
}
