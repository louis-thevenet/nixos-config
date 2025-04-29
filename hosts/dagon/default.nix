_: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./nextcloud.nix
    ./glance.nix
    ./nginx.nix
    ../common/global/nix.nix
    ../common/global/locale.nix
    ../common/users/louis
  ];
  networking.hostName = "dagon";

  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  security.rtkit.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 22 ];
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "24.11";

}
