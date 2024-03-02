{
  self,
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    nginx.virtualHosts = {
      "nc.louis-thevenet.fr" = {
        forceSSL = true;
        enableACME = true;
      };
    };

    nextcloud = {
      enable = true;
      hostName = "nc.louis-thevenet.fr";

      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud28;

      # Let NixOS install and configure the database automatically.
      database.createLocally = true;

      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;

      # Increase the maximum file upload size to avoid problems uploading videos.
      maxUploadSize = "16G";
      https = true;
      enableBrokenCiphersForSSE = false;

      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts mail notes tasks;
      };

      config = {
        overwriteProtocol = "https";
        defaultPhoneRegion = "FR";
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = config.sops.secrets."nextcloud-admin-password".path;
      };
    };
  };
}
