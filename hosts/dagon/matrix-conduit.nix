{ outputs, ... }:
let
  server_name = "matrix.ltvnt.com";
  address = "127.0.0.1";
  port = 6167;
in
{
  imports = [ outputs.nixosModules.maunium-stickerpicker ];
  services = {
    matrix-conduit = {
      enable = true;
      settings.global = {
        inherit address port server_name;
        allow_encryption = true;
        allow_federation = true;
        allow_registration = true;
        database_backend = "rocksdb";
        trusted_servers = [ "matrix.org" ];
      };
    };

    maunium-stickerpicker = {
      enable = true;
      domain = "stickers.ltvnt.com";
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
