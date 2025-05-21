_: {
  networking.firewall.allowedTCPPorts = [
    8096
  ];
  services = {
    nginx = {
      virtualHosts."jellyfin.louis-thevenet.fr" = {
        forceSSL = true;
        enableACME = true; # automatic Let's Encrypt
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };
    jellyfin = {
      enable = true;
      user = "louis";
    };
  };
}
