{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in
{
  home.packages = mkIf cfg.wayland.hyprland.enable (
    with pkgs;
    [
      hypridle
    ]
  );

  home.file.".config/hypr/hypridle.conf".text =
    let
      hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
      loginctl = "${pkgs.systemd}/bin/loginctl";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
    in
    ''
      $lock_cmd = ${hyprlock}
      $before_sleep_cmd = ${loginctl} lock-session
      $after_sleep_cmd = ${hyprctl}

      general {
          lock_cmd = $lock_cmd
          before_sleep_cmd = $before_sleep_cmd
          after_sleep_cmd = $after_sleep_cmd
      }

      listener {
          timeout = ${builtins.toString cfg.wayland.hypridleConfig.lockTime}
          on-timeout = ${hyprlock}
      }

      listener {
          timeout = ${builtins.toString cfg.wayland.hypridleConfig.screenDimTime}
          on-timeout =  ${hyprctl} dispatch dpms off
          on-resume =  ${hyprctl} dispatch dpms on
      }

      listener {
          timeout = ${builtins.toString cfg.wayland.hypridleConfig.suspendTime}
          on-timeout = ${systemctl} suspend
      }
    '';
}
