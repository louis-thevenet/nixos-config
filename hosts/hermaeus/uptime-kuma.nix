{ config, ... }:
let
  domain = "uptime.ltvnt.com";
  pushDomain = "ntfy.ltvnt.com";
in
{
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "127.0.0.1";
      # 3001 is already used by git-pages.
      PORT = "3004";
    };
  };

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://${pushDomain}";
      listen-http = "127.0.0.1:2586";
      behind-proxy = true;
      auth-default-access = "deny-all";
      # iOS uses this relay to wake the app, which fetches the message here.
      upstream-base-url = "https://ntfy.sh";
    };
  };

  services.nginx.virtualHosts = {
    ${domain} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${config.services.uptime-kuma.settings.PORT}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_read_timeout 300s;
        '';
      };
    };
    ${pushDomain} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${config.services.ntfy-sh.settings.listen-http}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          proxy_buffering off;
          proxy_read_timeout 1h;
        '';
      };
    };
  };
}
