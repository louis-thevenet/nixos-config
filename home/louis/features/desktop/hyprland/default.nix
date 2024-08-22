{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  imports = [
    ./window-binds.nix
    ./binds.nix
    ./decoration.nix
  ];
  wayland.windowManager.hyprland = mkIf cfg.hyprland.enable {
    # Whether to enable Hyprland wayland compositor
    enable = true;

    # Whether to enable XWayland
    xwayland.enable = true;

    extraConfig = let
      swaync = "${pkgs.swaynotificationcenter}/bin/swaync";
      hypridle = "${pkgs.hypridle}/bin/hypridle";
      copyq = "${pkgs.copyq}/bin/copyq";
    in ''
      exec-once = ${swaync}
      exec-once = ${hypridle}
      exec-once = ${copyq}
    '';

    settings = {
      input = {
        kb_layout = "fr";
        kb_variant = "azerty";
        numlock_by_default = true;
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };
      monitor =
        map
        (
          m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},1"
            else "disable"
          }"
        )
        (config.monitors)
        ++ [",preferred,auto,1"];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
        vfr = "on";
        focus_on_activate = true;
      };

      windowrule = [
        "tile,Warp"
        "float,^(Rofi)$"
      ];
    };
  };
}
