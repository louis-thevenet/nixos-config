_: {
  services.nginx = {
    enable = true;
    virtualHosts."_" = { };
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "louis.thevenet@proton.me";
  };

}
