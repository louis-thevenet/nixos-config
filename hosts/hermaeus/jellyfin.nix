{lib, ...}: {
  networking.firewall.allowedTCPPorts = [
    8096
  ];
  users.users = {
    jellyfin = {
      isSystemUser = true;
      group = "jellyfin";
      extraGroups = [
        "nextcloud" # so that I can store my jellyfish library in Nextcloud data
      ];
    };
  };
  users.groups.jellyfin = { };
  systemd.services.jellyfin.serviceConfig.PrivateUsers = lib.mkForce false;
  systemd.tmpfiles.rules = [
    "a+ /ssd - - - - u:jellyfin:rx"
  ];
  services = {
    nginx = {
      virtualHosts."jellyfin.ltvnt.com" = {
        forceSSL = true;
        enableACME = true; # automatic Let's Encrypt
        kTLS = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };
    jellyfin = {
      enable = true;
      user = "jellyfin";
    };
  };
}
