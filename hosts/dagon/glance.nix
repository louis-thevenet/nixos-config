{
  #lib,
  config,
  ...
}:
let
  host = "localhost";
  port = 4321;
in
{

  networking.firewall.allowedTCPPorts = [
    port
  ];
  services = {
    anubis.instances.glance.settings.TARGET = "http://${host}:${toString port}";
    nginx.virtualHosts."db.louis-thevenet.fr" = {
      forceSSL = true;
      enableACME = true; # automatic Let's Encrypt
      locations = {
        "/".proxyPass = "http://unix:${config.services.anubis.instances.glance.settings.BIND}";
        "/".extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    glance = {
      enable = true;
      # TODO: get config from HM config
    };
  };
}
