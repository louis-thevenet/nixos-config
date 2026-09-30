{ ... }:
let
  domain = "tasks.ltvnt.com";
  address = "127.0.0.1";
  port = 3456;
in
{
  services = {
    vikunja = {
      enable = true;
      frontendScheme = "https";
      frontendHostname = domain;
      inherit address port;
      database = {
        type = "postgres";
        host = "/run/postgresql";
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "vikunja" ];
      ensureUsers = [
        {
          name = "vikunja";
          ensureDBOwnership = true;
        }
      ];
    };

    nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${address}:${toString port}";
        proxyWebsockets = true;
      };
    };
  };
}
