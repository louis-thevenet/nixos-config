{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
  niri = lib.getExe pkgs.niri-unstable;
  displayOffListener = lib.optionalString (cfg.wayland.hypridleConfig.displayOffTime > 0) ''
    listener {
        timeout = ${builtins.toString cfg.wayland.hypridleConfig.displayOffTime}
        on-timeout = ${niri} msg action power-off-monitors
    }
  '';
in
{
  home.packages = mkIf cfg.wayland.enable (
    with pkgs;
    [
      hypridle
    ]
  );

  home.file.".config/hypr/hypridle.conf" = mkIf cfg.wayland.enable {
    text =
      let
        hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
        loginctl = "${pkgs.systemd}/bin/loginctl";
        systemctl = "${pkgs.systemd}/bin/systemctl";
      in
      ''
        $lock_cmd = ${hyprlock}
        $before_sleep_cmd = ${loginctl} lock-session
        general {
            lock_cmd = $lock_cmd
            before_sleep_cmd = $before_sleep_cmd
        }

        listener {
            timeout = ${builtins.toString cfg.wayland.hypridleConfig.lockTime}
            on-timeout = ${hyprlock}
        }

        listener {
            timeout = ${builtins.toString cfg.wayland.hypridleConfig.suspendTime}
            on-timeout = ${systemctl} suspend
        }
      '';
  };

  home.file.".config/hypr/display-off-hypridle.conf" = mkIf
    (cfg.wayland.enable && cfg.wayland.hypridleConfig.displayOffTime > 0)
    {
      text = ''
        general {
            ignore_wayland_inhibit = true
        }

        ${displayOffListener}
      '';
    };
}
