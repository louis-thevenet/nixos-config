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
  wayland = mkIf cfg.hyprland.enable {
    windowManager.hyprland.settings = {
      bindl =
        let
          playerctl = "${pkgs.playerctl}/bin/playerctl";
        in
        [
          ",XF86AudioPlay, exec, ${playerctl} play-pause"
          ",XF86AudioNext, exec, ${playerctl} next"
          ",XF86AudioPrev, exec, ${playerctl} previous"
        ];

      bindr =
        let
          killall = "${pkgs.killall}/bin/killall";
          socat = lib.getExe pkgs.socat;
        in
        # Waybar
        [ "SUPER,x,exec,${killall} -SIGUSR1 .waybar-wrapped" ]
        # Launcher
        ++ [
          # <https://albertlauncher.github.io/gettingstarted/faq/#how-to-make-hotkeys-work-on-wayland>
          "SUPER,d,exec,echo -n toggle | ${socat} - ~/.cache/albert/ipc_socket"
        ];
      binde =
        let
          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          pactl = "${pkgs.pulseaudio}/bin/pactl";
        in
        [
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

      bind =
        let
          hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
          systemctl = "${pkgs.systemd}/bin/systemctl";
          poweroff = "${pkgs.systemd}/bin/poweroff";
          swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
          grimblast = "${pkgs.grimblast}/bin/grimblast";
          terminal = config.home.sessionVariables.TERMINAL;
          darkman = "${pkgs.darkman}/bin/darkman";
          copyq = "${pkgs.copyq}/bin/copyq";
          bluetui = "${pkgs.bluetui}/bin/bluetui";
          hyprctl = lib.getExe' pkgs.hyprland "hyprctl";
        in
        [
          "SUPER,T,exec,${terminal}"

          #"SUPER, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy" # Clipboard manager
          "SUPER,C,exec,${copyq} show" # Clipboard manager

          # Screenshotting
          ",Print,exec,${grimblast} --notify copy area"
          "ALT,Print,exec,${grimblast} --notify save area"
          "SHIFT,Print,exec,${grimblast} --notify copy active"
          "CONTROL,Print,exec,${grimblast} --notify copy screen"
          "SUPER,Print,exec,${grimblast} --notify copy window"
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
            "SUPER,p,exec,${terminal} ${bluetui}"
          ]
        ++
          # Darkman toggle
          [
            "SUPERSHIFT,T,exec,${darkman} toggle"
          ]
        # Power button
        ++ [
          ",xf86poweroff ,exec, ${systemctl} suspend"
          "SUPER,xf86poweroff ,exec, ${poweroff}"
        ]
        ++ [
          "SUPER,s,exec,${hyprctl} switchxkblayout steelseries-steelseries-apex-7 next"
        ];
    };
  };
}
