{
  outputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
  # Dependencies
  cut = "${pkgs.coreutils}/bin/cut";
  wc = "${pkgs.coreutils}/bin/wc";
  jq = "${pkgs.jq}/bin/jq";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  btm-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.bottom}/bin/btm";
  nmtui-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.networkmanager}/bin/nmtui";
  nvtop-kitty = "${pkgs.kitty}/bin/kitty ${pkgs.nvtopPackages.nvidia}/bin/nvtop";
  # Function to simplify making waybar outputs
  jsonOutput =
    name:
    {
      pre ? "",
      text ? "",
      tooltip ? "",
      alt ? "",
      class ? "",
      percentage ? "",
    }:
    "${pkgs.writeShellScriptBin "waybar-${name}" ''
      set -euo pipefail
      ${pre}
      ${jq} -cn \
        --arg text "${text}" \
        --arg tooltip "${tooltip}" \
        --arg alt "${alt}" \
        --arg class "${class}" \
        --arg percentage "${percentage}" \
        '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
    ''}/bin/waybar-${name}";
in
{
  stylix.targets.waybar.enable = false;
  programs.waybar = mkIf cfg.hyprland.enable {
    enable = true;
    systemd.enable = true;
    settings = {
      primary = {
        layer = "top";
        position = "bottom";
        exclusive = false;
        fixed-center = false;
        start_hidden = true;
        modules-left =
          lib.optionals config.wayland.windowManager.hyprland.enable [
            "hyprland/workspaces"
            #"hyprland/submap"
          ]
          ++ [
            "cpu"
            "memory"
          ];
        modules-center = [
          "custom/player"
          #"custom/gpu"
        ];
        modules-right = [
          "tray"
          "network"
          "battery"
          "idle_inhibitor"
          "custom/currentplayer"
          "pulseaudio"
          "backlight"
          "custom/notifications"
          "clock"
        ];
        clock = {
          format = "{:%d/%m %H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        cpu = {
          format = " {usage}%";
          on-click = btm-kitty;
        };
        "custom/gpu" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gpu" {
            text = "";
            tooltip = "";
          };
          on-click = "${nvtop-kitty}";
          format = "{} %";
        };
        memory = {
          format = "󰍛 {}%";
          on-click = btm-kitty;
          interval = 5;
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " 0%";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = pavucontrol;
        };
        "custom/notifications" = {
          tooltip = false;
          format = "{} {icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which ${swaync-client}";
          exec = "${swaync-client} -swb";
          on-click = "${swaync-client} -t -sw";
          on-click-right = "${swaync-client} -d -sw";
          escape = true;
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = " ";
            "deactivated" = " ";
          };
        };
        "hyprland/workspaces" = {
          format-window-separator = "";
          active-only = false;
          all-outputs = false;
          show-special = true;
          window-rewrite-default = "";
          format = "{name}{windows}";
          "window-rewrite" = {
            "title<.*youtube.*>" = " ";
            "class<firefox>" = " ";
            "class<firefox> title<.*github.*>" = " ";
            "warp" = " ";
            "kitty" = " ";
            "codium-url-handler" = " 󰨞";
            "Discord" = " 󰙯";
            "spotube" = " 󰓇";
            "matlab" = "󰆧";
            "Super Productivity" = " 󰨟";
            "Beeper" = " 💬";
            "LM Studio" = " ";
          };
        };
        battery = {
          bat = cfg.hyprland.waybarConfig.batteryName;
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "sway/window" = {
          max-length = 20;
        };
        network = {
          interval = 3;
          format-wifi = "  {essid}";
          format-ethernet = "󰈁";
          format-disconnected = "";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = nmtui-kitty;
        };
        "custom/hostname" = {
          exec = "echo $USER@$HOSTNAME";
        };
        "backlight" = {
          "device" = "intel_backlight";
          "format" = "{icon} {percent}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotube" = "󰓇";
            "ncspot" = "󰓇";
            "qutebrowser" = "󰖟";
            "firefox" = " ";
            "discord" = "󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status";
          exec = ''
            ${playerctl} metadata --format '{"text": "{{artist}} - {{title}}", "alt": "{{status}}", "tooltip": "{{title}} ({{artist}} - {{album}})"}' | sed 's/\&/&amp;/g'
          '';
          return-type = "json";
          interval = 2;
          #max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };
      };
    };
    # Cheatsheet:
    # x -> all sides
    # x y -> vertical, horizontal
    # x y z -> top, horizontal, bottom
    # w x y z -> top, right, bottom, left

    style =
      with config.lib.stylix;
      # css
      ''
        * {
          font-size: 10pt;
          font-family: "Fira Code Nerd Font";
          font-weight: bold;
          transition-property: background-color;
          transition-duration: 0.5s;
        }
        window#waybar {
            background-color: transparent;
        }
        #workspaces button.focused,
        #workspaces button.active,
        #clock,
        #cpu,
        #memory,
        #custom-notifications,
        #custom-hostname,
        #battery,
        #idle_inhibitor,
        #network,
        #pulseaudio,
        #backlight,
        #tray,
        #custom-currentplayer,
        #custom-player
        {
            background-color:  #${colors.base01}; /* 01 */
            color: #${colors.base06}; /* 05 */
            padding: 0px 10px;
            border-radius: 10px;
            margin: 4px;
            border: 1px solid #${colors.base06};
        }
        #workspaces button {
            border-radius: 5;
            padding: 0 10px
        }
        #workspaces button,
        #workspaces button.hidden
        {
            background-color: #${colors.base01}; /* 0A */
            color: #${colors.base05}; /* 00 */
            padding: 0px 10px;
            border-radius: 10px;
            margin: 4px;
            border: 1px solid #${colors.base06};
        }
      '';
  };
}
