{ pkgs, config, ... }:
let
  domain = "karakeep.louis-thevenet.fr";
  meili-port = 2431;
  browser-port = 4213;
  ui-port = 4231;
in
{
  sops.secrets.karakeep-env = {
    sopsFile = ../common/secrets.yaml;
    owner = "karakeep";
  };
  sops.secrets.meili-search-master-key = {
    sopsFile = ../common/secrets.yaml;
  };
  services.meilisearch = {
    enable = true;
    package = pkgs.meilisearch;
    masterKeyEnvironmentFile = config.sops.secrets.meili-search-master-key.path;
    listenPort = meili-port;
    dumplessUpgrade = true;
  };
  systemd.services.karakeep = {
    serviceConfig = {
      UMask = "0027";
      # ExecStartPre = ''umask 0027''; # for restic backups
      # so that members of karakeep group can read every karakeep files
    };
  };
  services = {
    nginx.virtualHosts."${domain}" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString ui-port}";
    };

    karakeep = {
      enable = true;
      meilisearch.enable = true;
      browser.enable = true;
      browser.port = browser-port;
      extraEnvironment = {
        PORT = "${toString ui-port}";
        DISABLE_SIGNUPS = "true";
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
      environmentFile = config.sops.secrets.karakeep-env.path;
    };

  };
}
