{ ... }:
let
  host = "ai.ltvnt.com";
  port = 4312;
in
{

  services = {
    nginx = {
      virtualHosts."ai.ltvnt.com" = {
        forceSSL = true;
        enableACME = true; # automatic Let's Encrypt
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
    open-webui = {
      enable = true;
      inherit port;
      environment = {
        WEBUI_URL = host;
        ENABLE_SIGNUP = "false";
      };
    };
  };
}
