{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in {
  wayland = mkIf cfg.hyprland.enable {
    windowManager.hyprland.settings.binde = let
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      pactl = "${pkgs.pulseaudio}/bin/pactl";
    in [
      # Brightness
      ",XF86MonBrightnessUp,exec,${brightnessctl} set +5%"
      ",XF86MonBrightnessDown,exec,${brightnessctl} set 5%-"
      # Volume
      ",XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
      ",XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
      "SHIFT,XF86AudioRaiseVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ +1%"
      "SHIFT,XF86AudioLowerVolume,exec,${pactl} set-sink-volume @DEFAULT_SINK@ -1%"
      ",XF86AudioMute,exec,${pactl} set-sink-mute @DEFAULT_SINK@ toggle"
      "SHIFT,XF86AudioMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
      ",XF86AudioMicMute,exec,${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
    ];

    windowManager.hyprland.settings.bind = let
      hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
      swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      grimblast = "${pkgs.grimblast}/bin/grimblast";
      terminal = config.home.sessionVariables.TERMINAL;
      killall = "${pkgs.killall}/bin/killall";
    in
      [
        "SUPER,T,exec,${terminal}"

        #"SUPER, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy" # Clipboard manager
        "SUPER, C, exec, copyq show" # Clipboard manager

        # Screenshotting
        ",Print,exec,${grimblast} --notify copy area"
        "ALT,Print,exec,${grimblast} --notify save area"
        "SHIFT,Print,exec,${grimblast} --notify copy active"
        "CONTROL,Print,exec,${grimblast} --notify copy screen"
        "SUPER,Print,exec,${grimblast} --notify copy window"
      ]
      # Launcher
      ++ [
        "SUPER,x,exec,rofi -show drun -sidebar-mode"
        "SUPERSHIFT,x,exec,rofi -show run"
        "SUPER,tab,exec,rofi -show window"
      ]
      # Waybar
      ++ [
        "SUPERSHIFT,w,exec,${killall} -SIGUSR1 .waybar-wrapped"
      ]
      ++
      # Screen lock
      [
        ",XF86Launch5,exec,${hyprlock}"
        ",XF86Launch4,exec,${hyprlock}"
        "SUPER,backspace,exec,${hyprlock}"
      ]
      ++
      # Notification manager
      [
        "SUPER,w,exec,${swaync-client} -t" # cp closes
      ]
      ++
      # Bluetooth
      [
        "SUPER,p,exec,blueman-manager"
      ];
  };
}
