_: {
  services.nginx = {
    enable = true;
    virtualHosts."nc.louis-thevenet.fr" = {
      forceSSL = true;
      enableACME = true; # automatic Let's Encrypt
    };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "louis.thevenet@proton.me";
  };

}
