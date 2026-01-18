{
  inputs,
  outputs,
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
    ./jellyfin.nix
    ./nginx.nix
    ./karakeep.nix
    ./restic.nix
    ./adguardhome.nix
    ./hugo.nix
    ./firefly-iii.nix
    ./matrix-conduit.nix
    ../common/global/nix.nix
    ../common/global/nixpkgs.nix
    ../common/global/user.nix
    ../common/global/openssh.nix
    ../common/global/locale.nix
    ../common/optional/stylix.nix
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];
  networking.hostName = "dagon";
  networking.hosts = {
    "192.168.1.37" = [
      "db.ltvnt.com"
      "nc.ltvnt.com"
      "blog.ltvnt.com"
      "jellyfin.ltvnt.com"
      "karakeep.ltvnt.com"
      "firefly.ltvnt.com"
      "matrix.ltvnt.com"
      "stickers.ltvnt.com"
    ];
  };
  programs.fish.enable = true;
  programs.dconf.enable = true;
  console.keyMap = "fr";

  security.rtkit.enable = true;
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };
  documentation.man.generateCaches = false;
  system.stateVersion = "25.11";

}
