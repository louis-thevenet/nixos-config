{
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./nextcloud.nix
    ./glance.nix
    ./anubis.nix
    # ./jellyfin.nix
    ./nginx.nix
    # ./karakeep.nix
    # ./restic.nix
    # ./adguardhome.nix
    # ./hugo.nix
    # ./firefly-iii.nix
    ./matrix-conduit.nix
    ../common/global
  ];
  networking.hostName = "hermaeus";

  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  security.rtkit.enable = true;
  networking = {
    networkmanager.enable = true;
    firewall.enable = lib.mkForce false;
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "26.05";

}
