{
  config,
  pkgs,
  ...
}:
let
  python = pkgs.python3.withPackages (ps: [ (ps.matrix-nio.override { withVodozemac = true; }) ]);
in
{
  sops.secrets = {
    "vikunja-matrix/password" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ "vikunja-matrix.service" ];
    };
    "vikunja-matrix/room-id" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ "vikunja-matrix.service" ];
    };
    "vikunja-matrix/webhook-secret" = {
      sopsFile = ../secrets.yaml;
      restartUnits = [ "vikunja-matrix.service" ];
    };
  };
  systemd.services.vikunja-matrix = {
    description = "Vikunja webhook to Matrix receiver";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    environment = {
      MATRIX_HOMESERVER = "https://matrix.ltvnt.com";
      MATRIX_USER_ID = "@vikunja:matrix.ltvnt.com";
    };
    serviceConfig = {
      ExecStart = "${python}/bin/python3 ${./receiver.py}";
      LoadCredential = [
        "password:${config.sops.secrets."vikunja-matrix/password".path}"
        "room_id:${config.sops.secrets."vikunja-matrix/room-id".path}"
        "webhook_secret:${config.sops.secrets."vikunja-matrix/webhook-secret".path}"
      ];
      DynamicUser = true;
      StateDirectory = "vikunja-matrix";
      StateDirectoryMode = "0700";
      Restart = "on-failure";
      RestartSec = 5;
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      UMask = "0077";
    };
  };

  services.nginx.virtualHosts."tasks.ltvnt.com".locations."= /vikunja-matrix" = {
    proxyPass = "http://127.0.0.1:3457";
    extraConfig = ''
      client_max_body_size 1m;
      proxy_connect_timeout 5s;
      proxy_read_timeout 15s;
    '';
  };
}
