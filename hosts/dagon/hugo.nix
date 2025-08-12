{ inputs, config, pkgs, ... }:
let
  internal_port = 6451;
in
{
  networking.firewall.allowedTCPPorts = [
    internal_port
  ];
  services = {
    static-web-server = {
      enable = true;
      root = "${inputs.blog.packages.${pkgs.system}.default}";
      listen = "[::]:${toString internal_port}";
    };
    nginx.virtualHosts."blog.louis-thevenet.fr" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:${config.services.anubis.instances.blog.settings.BIND}";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
    anubis.instances.blog = {
      enable = true;
      settings.TARGET = "http://[::1]:${toString internal_port}";
    };
  };
}
