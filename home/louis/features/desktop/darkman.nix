{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf optionalString concatStringsSep;
  wayland-cfg = config.home-config.desktop.wayland;
  cfg = config.home-config.desktop;
in
{
  services.darkman =
    let
      swaync-client = lib.getExe' pkgs.swaynotificationcenter "swaync-client";
      killall = lib.getExe' pkgs.toybox "killall";
      albert = lib.getExe pkgs.albert;

      find-hm-generation =
        let
          home-manager = "${pkgs.home-manager}/bin/home-manager";
          grep = lib.getExe' pkgs.toybox "grep";
          head = lib.getExe' pkgs.toybox "head";
          find = lib.getExe' pkgs.toybox "find";
        in
        ''
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

      switch-theme-script =
        theme:
        concatStringsSep "\n" [
          "$(${find-hm-generation})/${theme}/activate"
          "${killall} -SIGUSR1 hx" # enabled by default
          (optionalString wayland-cfg.enable "${swaync-client} -rs") # reload CSS for swaync (notification center)
          (optionalString wayland-cfg.enable "${albert} restart")
        ];
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
        lat = 49;
        lng = 2;
        dbusserver = true;
      };
    };
  # restart darkman after switching to new configuration
  systemd.user.services.darkman.Unit.X-SwitchMethod = "restart";
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.darkman ];
    config.common."org.freedesktop.impl.portal.Settings" = "darkman";
  };
}
