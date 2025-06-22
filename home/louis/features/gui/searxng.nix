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
  karakeep-engine = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/louis-thevenet/searxng-karakeep-engine/refs/heads/main/karakeep.py";
    hash = "sha256-s0p4AAan7cgncIyZPvOrNQLektTRYV0V1R9UKAtfpJQ=";
  };
  searxngWithEngine = pkgs.searxng.overrideAttrs (_: {
    # Inject karakeep.py into engines
    postPatch = ''
      mkdir -p $out/lib/python3.12/site-packages/searx/engines
      cat ${karakeep-engine} > $out/lib/python3.12/site-packages/searx/engines/karakeep.py
    '';
  });

in
{
  sops.secrets.karakeep-api-key = {
    sopsFile = ../../../../hosts/common/secrets.yaml;
  };
  sops.templates."settings.yaml".content = ''
    # https://docs.searxng.org/admin/settings/settings.html#settings-yml-location
    # The initial settings.yml we be load from these locations:
    # * the full path specified in the SEARXNG_SETTINGS_PATH environment variable.
    # * /etc/searxng/settings.yml

    # Default settings see <pkgs.searxng>/lib/python3.11/site-packages/searx/settings.yml
    use_default_settings: true

    search:
      autocomplete: "google"
      default_lang: "en"

    engines:
      - name: karakeep
        engine: karakeep
        base_url: 'https://karakeep.louis-thevenet.fr/'
        number_of_results: 3
        timeout: 3.0
        api_key: ${config.sops.placeholder.karakeep-api-key}


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
        "SEARXNG_SETTINGS_PATH=${config.sops.templates."settings.yaml".path}"
      ];
      ExecStart = lib.getExe searxngWithEngine;
    };
  };
}
