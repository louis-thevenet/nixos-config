{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.misc;
in
{
  services.nextcloud-client = mkIf cfg.nextcloud.enable {
    enable = true;
    startInBackground = true;
  };
}
