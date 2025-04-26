{
  pkgs,
  config,
  ...
}:
{
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;

    hostName = "nc.louis-thevenet.fr";
    maxUploadSize = "16G";
    https = true;
    home = "/nextcloud_data";
    extraAppsEnable = true;
    # extraApps = with pkgs.nextcloud30Packages.apps; {
    # inherit
    #   bookmarks
    #   calendar
    #   contacts
    #   cospend
    #   deck
    #   forms
    #   polls
    #   tasks
    #   ;
    # };

    config = {
      # Nextcloud PostegreSQL database configuration, recommended over using SQLite
      dbtype = "pgsql";
      dbuser = "nextcloud";
      dbhost = "/run/postgresql";
      dbname = "nextcloud";

      adminuser = "admin";
      adminpassFile = config.sops.secrets.nextcloud-admin-pass.path;
    };

    settings = {
      # Further forces Nextcloud to use HTTPS
      overwriteProtocol = "https";
    };
  };

  sops.secrets.nextcloud-admin-pass = {
    sopsFile = ./secrets.yaml;
    owner = "nextcloud";
  };

  # Enable PostgreSQL
  services.postgresql = {
    enable = true;
    # Ensure the database, user, and permissions always exist
    ensureDatabases = [ "nextcloud" ];
    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
    ];
  };

  # Ensure that postgres is running before running the setup
  systemd.services."nextcloud-setup" = {
    requires = [ "postgresql.service" ];
    after = [ "postgresql.service" ];
  };

  # services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
  #   forceSSL = true;
  #   useACMEHost = "louis-thevenet.fr";
  # };

}
