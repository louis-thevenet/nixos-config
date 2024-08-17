{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  services.darkman = let
    swaync-client = "${pkgs.swaynotificationcenter}/bin/sway-nc-client";
    systemctl = "${pkgs.systemd}/bin/systemctl";

    find-hm-generation = let
      home-manager = "${pkgs.home-manager}/bin/home-manager";
      grep = "${pkgs.toybox}/bin/grep";
      head = "${pkgs.toybox}/bin/head";
      find = "${pkgs.toybox}/bin/find";
    in ''
      for line in $(${home-manager} generations | ${grep} -o '/.*')
      do
        res=$(${find} $line | ${grep} specialisation | ${head} -1)
        output=$?
        if [[ $output -eq 0 ]] && [[ $res != "" ]]; then
            echo $res
            exit
        fi
      done
    '';

    switch-theme-script = theme: ''
      $(${find-hm-generation})/${theme}/activate
      ${swaync-client} -rs # reload CSS for swaync (notification center)
      ${systemctl} --user restart hyprpaper.service
    '';
  in
    mkIf cfg.stylix.enable {
      enable = true;
      darkModeScripts = {
        activate = switch-theme-script "dark";
      };
      lightModeScripts = {
        activate = switch-theme-script "light";
      };
      settings = {
        lat = 48.86;
        lng = 2.35;
        dbusserver = true;
      };
    };
}
