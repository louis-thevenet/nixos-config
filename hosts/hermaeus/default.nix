{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  portfolioSite = inputs.portfolio.packages.${system}.default;
  url = "portfolio.ltvnt.com";
in
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ./nextcloud.nix
    ./jellyfin.nix
    ./nginx.nix
    ./matrix-conduit.nix
    ./forgejo.nix
    ../common/global
  ];
  networking.hostName = "hermaeus";
  services.nginx = {
    enable = true;
    virtualHosts.${url} = {
      root = "${portfolioSite}";
      enableACME = true;
      forceSSL = true;
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
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
