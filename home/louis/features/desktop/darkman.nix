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
  in
    mkIf cfg.stylix.enable {
      enable = true;
      darkModeScripts = {
        activate = ''
          $(${find-hm-generation})/dark/activate
          swaync-client -rs # reload CSS for swaync (notification center)
        '';
      };
      lightModeScripts = {
        activate = ''
          $(${find-hm-generation})/light/activate
          swaync-client -rs # reload CSS for swaync (notification center)
        '';
      };
      settings = {
        lat = 48.86;
        lng = 2.35;
        dbusserver = true;
      };
    };
}
