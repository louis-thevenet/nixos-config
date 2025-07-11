{
  pkgs,
  ...
}:

{
  services.atticd = {
    enable = true;

    settings = {
      listen = "0.0.0.0:5000";
      database.url = "sqlite:///var/lib/atticd/server.db";

      storage = {
        type = "local";
        path = "/var/lib/atticd/storage";
      };

      chunking = {
        nar-size-threshold = 33554432;
        min-size = 16384;
        avg-size = 65536;
        max-size = 262144;
      };

      compression = {
        type = "zstd";
        level = 3;
      };

      garbage-collection = {
        interval = 43200;
        default-retention-period = 604800;
      };
    };

    package = pkgs.attic-server;
    user = "atticd";
    group = "atticd";
  };

  networking.firewall.allowedTCPPorts = [ 5000 ];

  systemd.tmpfiles.rules = [
    "d /var/lib/atticd 0755 atticd atticd -"
    "d /var/lib/atticd/storage 0755 atticd atticd -"
  ];

  environment.systemPackages = with pkgs; [
    attic-client
    sqlite
  ];
}
