{ config, ... }:
let
  domain = "analytics.ltvnt.com";
  port = 3020;
in
{
  sops.secrets.umami-app-secret = {
    sopsFile = ./secrets.yaml;
    restartUnits = [ "umami.service" ];
  };

  services = {
    umami = {
      enable = true;
      settings = {
        APP_SECRET_FILE = config.sops.secrets.umami-app-secret.path;
        HOSTNAME = "127.0.0.1";
        PORT = port;
        DISABLE_TELEMETRY = true;
      };
    };

    nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:${toString port}";
    };
  };
}
