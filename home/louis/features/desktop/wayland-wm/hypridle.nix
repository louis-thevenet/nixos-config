{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  home.packages = mkIf cfg.hyprland.enable (with pkgs; [
    hypridle
  ]);

  # Suspend is broken
  home.file.".config/hypr/hypridle.conf".text = ''
    $lock_cmd = ${pkgs.hyprlock}/bin/hyprlock

    general {
        lock_cmd = $lock_cmd
    }

    listener {
        timeout = 120
        on-timeout = $lock_cmd
    }

    listener {
        timeout = 180
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
    }

  '';
}
