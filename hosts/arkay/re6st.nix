{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (inputs.re6st.packages.${pkgs.system}) re6st;
  copy-nix-store =
    name: pkgs.writeText name (builtins.readFile "${config.users.users.louis.home}/${name}");
  re6stnet-options = pkgs.writeText "re6stnet.conf" ''
    registry http://re6stnet.gnet.erp5.cn
    ca ${copy-nix-store "ca.crt"}
    cert ${copy-nix-store "cert.crt"}
    key ${copy-nix-store "cert.key"}
    interface wlp0s20f3
  '';

  geolite2-country-mmdb = pkgs.fetchurl {
    url = "https://github.com/P3TERX/GeoLite.mmdb/raw/download/GeoLite2-Country.mmdb";
    hash = "sha256-PPaezALpVEGaLMkt2JJjc2M+qmRk+swCXVU8uKQ4cFY=";
  };
  babeld-patched = pkgs.babeld.overrideAttrs (_: {
    src = pkgs.fetchFromGitLab {
      fetchSubmodules = true;
      owner = "nexedi";
      repo = "babeld";
      domain = "lab.nexedi.com";
      rev = "v1.12.1-nxd3";
      hash = "sha256-wkuSvywMdzAJVcX1yrL1vNqXwC4ETj9QQTFKMb6tuC8=";
    };
  });
  openvpn-2-4 =
    let
      pkcs11Support = false;
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "openvpn";
      version = "2.4.7";
      src = pkgs.fetchurl {
        url = "https://swupdate.openvpn.net/community/releases/openvpn-${version}.tar.gz";
        hash = "sha256-c9zlQu09bwVTZ09JAl373/GDSOuKJeYhUTXWhrFlQjw=";
      };
      nativeBuildInputs = with pkgs; [ pkg-config ];

      buildInputs =
        with pkgs;
        [
          lzo
          lz4
          openssl_1_1
          unixtools.route
          unixtools.ifconfig
        ]
        ++ lib.optional pkgs.stdenv.isLinux pkgs.pam
        ++ lib.optional pkcs11Support pkgs.pkcs11helper;

      postInstall = ''
        mkdir -p $out/share/doc/openvpn/examples
        cp -r sample/sample-{config-files,keys,scripts}/ $out/share/doc/openvpn/examples
      '';

      enableParallelBuilding = true;
    };

in
{
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  environment.defaultPackages = [
    re6st
    babeld-patched
  ];

  systemd.services.re6stnet = {
    enable = true;
    description = "Resilient, Scalable, IPv6 Network application";
    script = "GEOIP2_MMDB=${geolite2-country-mmdb} ${lib.getExe' re6st "re6stnet"} @${re6stnet-options}";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    path =
      with pkgs;
      [
        openssl
        iproute2
      ]
      ++ [
        babeld-patched
        openvpn-2-4
      ];
  };
}
