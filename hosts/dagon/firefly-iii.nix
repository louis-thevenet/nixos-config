{
  config,
  ...
}:
let
  virtHost = "firefly.ltvnt.com";
in
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  sops.secrets = {
    firefly-iii-app-key = {
      sopsFile = ./secrets.yaml;
      owner = "firefly-iii";
    };
    firefly-iii-db-pwd = {
      sopsFile = ./secrets.yaml;
      owner = "firefly-iii";
    };
  };
  services = {
    firefly-iii = {
      enable = true;
      enableNginx = true;
      dataDir = "/var/lib/firefly";
      virtualHost = virtHost;
      settings = {
        APP_ENV = "production";
        APP_KEY_FILE = config.sops.secrets.firefly-iii-app-key.path;
        TZ = "Europe/Paris";
      };
    };
    nginx.virtualHosts.${virtHost} = {
      forceSSL = true;
      enableACME = true;
    };
  };

}
