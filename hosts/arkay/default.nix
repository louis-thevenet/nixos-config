{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.re6st.packages.${pkgs.system}) re6st;
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
  environment.etc = {
    "re6stnet/re6st-registry.conf" = {
      text = ''

      '';

      mode = "0440";
    };
  };
  systemd.user.services.re6stnet = {
    description = "Resilient, Scalable, IPv6 Network application";
    unitConfig.ConditionPathExists = "/etc/re6stnet/re6st-registry.conf";
    StartLimitIntervalSec = 0;
    script = ''
      /bin/sh -c 'GEOIP2_MMDB=/etc/re6stnet/GeoLite2-Country.mmdb; [ -r $GEOIP2_MMDB ]
      && export GEOIP2_MMDB; exec re6stnet @re6stnet.conf'
    '';
    wantedBy = "multi-user.target";
  };
  systemd.user.services.re6stnet-registry = {
    description = "Server application for re6snet";
    unitConfig.ConditionPathExists = "/etc/re6stnet/re6st-registry.conf";
    StartLimitIntervalSec = 0;
    script = ''
      ${lib.getExe' re6st "re6st-registry"} @re6st-registry.conf
    '';
    wantedBy = "multi-user.target";
  };
}
