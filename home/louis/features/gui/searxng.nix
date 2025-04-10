{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui.firefox;
  inherit (cfg.searxngInstance) url;
  inherit (cfg.searxngInstance) port;

  searxng_yml = builtins.toFile "searxng.yml" ''
    # https://docs.searxng.org/admin/settings/settings.html#settings-yml-location
    # The initial settings.yml we be load from these locations:
    # * the full path specified in the SEARXNG_SETTINGS_PATH environment variable.
    # * /etc/searxng/settings.yml

    # Default settings see <pkgs.searxng>/lib/python3.11/site-packages/searx/settings.yml
    use_default_settings: true

    search:
      autocomplete: "google"
      default_lang: "en"

    server:
      port: ${toString port}
      bind_address: ${lib.removePrefix "http://" url}
      secret_key: "aaa"  
      base_url: false  # "http://example.com/location"
      # rate limit the number of request on the instance, block some bots.
      limiter: false
      # enable features designed only for public instances.
      public_instance: false
    ui:
      results_on_new_tab: true
  '';
in
{
  systemd.user.services.searxng = mkIf cfg.searxngInstance.local {
    Unit = {
      Description = "Auto start searxng";
      After = [ "network.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Environment = [
        "SEARXNG_SETTINGS_PATH=${searxng_yml}"
      ];
      ExecStart = lib.getExe pkgs.searxng;
    };
  };
}
