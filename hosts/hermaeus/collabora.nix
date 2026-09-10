{ config, ... }:
let
  domain = "office.ltvnt.com";
  nextcloudDomain = "nc.ltvnt.com";
  port = 9980;
in
{
  services = {
    collabora-online = {
      enable = true;
      inherit port;
      settings = {
        server_name = domain;
        ssl = {
          enable = false;
          termination = true;
        };
      };
      aliasGroups = [
        {
          host = "https://${nextcloudDomain}:443";
          aliases = [
            "https://${nextcloudDomain}"
            "https://${nextcloudDomain}:443"
          ];
        }
      ];
    };

    nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString port}";
        proxyWebsockets = true;
      };
    };
  };

  systemd.services.nextcloud-collabora-config = {
    description = "Configure Nextcloud Office to use Collabora Online";
    wantedBy = [ "multi-user.target" ];
    after = [ "nextcloud-setup.service" ];
    requires = [ "nextcloud-setup.service" ];
    path = [ config.services.nextcloud.occ ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      nextcloud-occ config:app:set richdocuments wopi_url --value=https://${domain}
    '';
  };
}
