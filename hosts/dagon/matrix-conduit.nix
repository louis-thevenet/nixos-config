_:
let
  server_name = "matrix.ltvnt.com";
  address = "127.0.0.1";
  port = 6167;
in
{

  services = {
    matrix-conduit = {
      enable = true;
      settings.global = {
        inherit address port server_name;
        allow_encryption = true;
        allow_federation = false;
        allow_registration = true;
        database_backend = "rocksdb";
        trusted_servers = [ "matrix.org" ];
      };
    };

    nginx = {
      virtualHosts.${server_name} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://${address}:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
