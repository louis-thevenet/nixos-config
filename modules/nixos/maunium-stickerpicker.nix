{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.maunium-stickerpicker;
in
{
  options.services.maunium-stickerpicker = {
    enable = mkEnableOption "Maunium Stickerpicker web service";

    domain = mkOption {
      type = types.str;
      example = "stickers.example.com";
      description = "Domain to serve the stickerpicker on";
    };

    enableSSL = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable SSL/TLS (requires ACME)";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/maunium-stickerpicker";
      description = "Directory for storing sticker packs and configuration";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0755 nginx nginx -"
      "d '${cfg.dataDir}/packs' 0755 nginx nginx -"
    ];

    environment.systemPackages = [ pkgs.maunium-stickerpicker.tools ];

    services.nginx = {
      enable = true;
      virtualHosts.${cfg.domain} = {
        forceSSL = cfg.enableSSL;
        enableACME = cfg.enableSSL;

        locations."/" = {
          root = "${pkgs.maunium-stickerpicker}/web";
          index = "index.html";
        };

        locations."/packs/" = {
          alias = "${cfg.dataDir}/packs/";
        };
      };
    };
  };
}
