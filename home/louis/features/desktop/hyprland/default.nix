{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop.wayland;
in
{
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
    extraConfig =
      let
        swaync = lib.getExe' pkgs.swaynotificationcenter "swaync";
        hypridle = lib.getExe pkgs.hypridle;
        copyq = lib.getExe pkgs.copyq;
        albert = lib.getExe pkgs.albert;
      in
      ''
        exec-once = ${swaync}
        exec-once = ${hypridle}
        exec-once = ${copyq}
        exec-once = ${albert}
      '';
    plugins = with pkgs.hyprlandPlugins; [
      hypr-dynamic-cursors
    ];
    settings = {
      env = [
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "NIXOS_OZONE_WL,1"
        "SDL_VIDEODRIVER,wayland"
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "CLUTTER_BACKEND,wayland"
        "WLR_RENDERER,vulkan"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];
      cursor = mkIf cfg.hyprland.nvidia {
        no_hardware_cursors = true;
      };
      input = {
        kb_layout = "fr";
        kb_variant = "azerty";

        numlock_by_default = true;
        kb_options = "fkeys:basic_13-24";
        touchpad = {
          disable_while_typing = false;
          natural_scroll = true;
        };
      };
      monitor =
        map (
          m:
          let
            resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            position = "${toString m.x}x${toString m.y}";
            scale = "${toString m.scale}";
          in
          "${m.name},${if m.enabled then "${resolution},${position},${scale}" else "disable"}"
        ) config.monitors
        ++ [ ",preferred,auto,1" ];

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };

      misc = {
        disable_splash_rendering = true;
        disable_hyprland_logo = true;
        mouse_move_enables_dpms = true;
        # enable_swallow = true;
        # swallow_regex = "^(kitty)$";
        vfr = "on";
        focus_on_activate = true;
      };

      windowrulev2 = [
        # keep focus on albert
        "stayfocused, class:(albert)"
        "float, class:(albert)"
        "center, class:(albert)"
      ];
    };
  };
}
