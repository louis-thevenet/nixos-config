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
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = "/home/louis/cache-priv-key.pem";
  };

  networking.firewall.allowedTCPPorts = [
    5000
  ];
  environment.defaultPackages = [
    re6st
  ];

  systemd.user.services.re6stnet = {
    description = "Resilient, Scalable, IPv6 Network application";
    script = "GEOIP2_MMDB=${geolite2-country-mmdb} ${lib.getExe re6st "re6stnet"} @${re6stnet-config}";
    # wantedBy = "multi-user.target";
  };
  systemd.user.services.re6stnet-registry = {
    description = "Server application for re6snet";
    script = "${lib.getExe' re6st "re6st-registry"} @${re6st-registry-config}";
    # wantedBy = "multi-user.target";
  };
}
