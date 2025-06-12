{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.re6st.packages.${pkgs.system}) re6st;
  re6stnet-config = pkgs.writeText "re6stnet.conf" '''';
  re6st-registry-config = pkgs.writeText "re6st-registry.conf" '''';
  geolite2-country-mmdb = pkgs.fetchurl {
    url = "https://github.com/P3TERX/GeoLite.mmdb/raw/download/GeoLite2-Country.mmdb";
    hash = "sha256-PPaezALpVEGaLMkt2JJjc2M+qmRk+swCXVU8uKQ4cFY=";
  };
in
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
