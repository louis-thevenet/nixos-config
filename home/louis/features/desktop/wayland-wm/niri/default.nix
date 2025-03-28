{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  binds =
    {
      suffixes,
      prefixes,
      substitutions ? { },
    }:
    let
      replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
      format =
        prefix: suffix:
        let
          actual-suffix =
            if isList suffix.action then
              {
                action = head suffix.action;
                args = tail suffix.action;
              }
            else
              {
                inherit (suffix) action;
                args = [ ];
              };

          action = replacer "${prefix.action}-${actual-suffix.action}";
        in
        {
          name = "${prefix.key}+${suffix.key}";
          value.action.${action} = actual-suffix.args;
        };
      pairs =
        attrs: fn:
        concatMap (
          key:
          fn {
            inherit key;
            action = attrs.${key};
          }
        ) (attrNames attrs);
    in
    listToAttrs (pairs prefixes (prefix: pairs suffixes (suffix: [ (format prefix suffix) ])));

  azerty = {
    "1" = "ampersand";
    "2" = "eacute";
    "3" = "quotedbl";
    "4" = "apostrophe";
    "5" = "parenleft";
    "6" = "minus";
    "7" = "egrave";
    "8" = "underscore";
    "9" = "ccedilla";
    "0" = "agrave";
  };

  toAzerty = n: set: if (builtins.elem n (lib.attrNames set)) then set.${n} else n;
  socat = lib.getExe pkgs.socat;
  killall = "${pkgs.killall}/bin/killall";
  brightnessctl = lib.getExe pkgs.brightnessctl;
  wpctl = lib.getExe' pkgs.wireplumber "wpctl";

  swaync-client = "${pkgs.swaynotificationcenter}/bin/swaync-client";
  terminal = config.home.sessionVariables.TERMINAL;
  hyprlock = lib.getExe pkgs.hyprlock;
  darkman = "${pkgs.darkman}/bin/darkman";
  copyq = "${pkgs.copyq}/bin/copyq";
  bluetui = "${pkgs.bluetui}/bin/bluetui";
in
{

  programs.niri.settings = {
    input = {
      keyboard.xkb.layout = "fr,fr";
      focus-follows-mouse.enable = true;
    };
    screenshot-path = "~/Pictures/Screenshots/%Y-%m-%dT%H:%M:%S.png";
    binds =
      with config.lib.niri.actions;
      let
        sh = spawn "sh" "-c";
      in
      lib.attrsets.mergeAttrsList [

        {
          # Apps
          "Mod+T".action = spawn terminal;
          "Mod+D".action = sh "echo -n toggle | ${socat} - ~/.cache/albert/ipc_socket";
          "Mod+x".action = sh "${killall} -SIGUSR1 .waybar-wrapped";
          "Mod+O".action = sh "${copyq} show";
          "Mod+W".action = sh "${swaync-client} -t";
          "Mod+P".action = sh "${terminal} ${bluetui}";
          "Mod+Shift+T".action = sh "${darkman} toggle";
          "Mod+Backspace".action = spawn hyprlock;
        }
        {
          # Functions
          "XF86AudioRaiseVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
          "XF86AudioLowerVolume".action = sh "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
          "XF86AudioMute".action = sh "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86MonBrightnessUp".action = sh "${brightnessctl} set 10%+";
          "XF86MonBrightnessDown".action = sh "${brightnessctl} set 10%-";

          "Print".action = screenshot;
          "Alt+Print".action = screenshot-window;
        }
        {
          # Other
          "Mod+colon".action = show-hotkey-overlay;
          "Mod+Q".action = close-window;
        }
        # Window binds
        (binds {

          suffixes = {
            "Left" = "column-left";
            "Down" = "window-down";
            "Up" = "window-up";
            "Right" = "column-right";
            "J" = "column-left";
            "K" = "window-down";
            "L" = "window-up";
            "M" = "column-right";
          };

          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move";
            "Mod+Shift" = "focus-monitor";
            "Mod+Shift+Ctrl" = "move-window-to-monitor";
          };
          substitutions = {
            "monitor-column" = "monitor";
            "monitor-window" = "monitor";
          };
        })
        {
          "Mod+V".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+V".action = toggle-window-floating;
        }
        (binds {
          suffixes = {
            "Home" = "first";
            "End" = "last";
          };
          prefixes = {
            "Mod" = "focus-column";
            "Mod+Ctrl" = "move-column-to";
          };
        })
        (binds {
          suffixes = {
            "U" = "workspace-down";
            "Page_Down" = "workspace-down";
            "WheelScrollDown" = "workspace-down";
            "I" = "workspace-up";
            "WheelScrollUp" = "workspace-up";
            "Page_Up" = "workspace-up";
          };
          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move-window-to";
            "Mod+Shift" = "move";
          };
        })
        (binds {
          suffixes = builtins.listToAttrs (
            map (n: {
              name = toString (toAzerty (toString n) azerty);
              value = [
                "workspace"
                n
              ];
            }) (range 1 9)
          );
          prefixes = {
            "Mod" = "focus";
            "Mod+Ctrl" = "move-window-to";
          };
        })
        {
          "Mod+Comma".action = consume-window-into-column;
          "Mod+semicolon".action = expel-window-from-column;

          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R" = switch-preset-window-height;
          "Mod+Ctrl+R" = reset-window-height;
          "Mod+F".action = maximize-column;
          "Mod+Shift+F".action = fullscreen-window;
          "Mod+C".action = center-column;

          "Mod+KP_Subtract".action = set-column-width "-10%";
          "Mod+KP_Add".action = set-column-width "+10%";
          "Mod+Shift+KP_Subtract".action = set-window-height "-10%";
          "Mod+Shift+KP_Add".action = set-window-height "+10%";

          "Mod+Shift+Escape".action = toggle-keyboard-shortcuts-inhibit;
          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;

          "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
        }
        {
          "Mod+Ctrl+F".action = expand-column-to-available-width;
        }
      ];
    layout = {
      gaps = 16;
      struts.left = 64;
      struts.right = 64;
      border.width = 4;
      always-center-single-column = true;

      empty-workspace-above-first = true;
      # fog of war
      focus-ring = {
        # enable = true;
        width = 10000;
        active.color = "#00000055";
      };
      # border.active.gradient = {
      #   from = "red";
      #   to = "blue";
      #   in' = "oklch shorter hue";
      # };

      shadow.enable = true;

      # default-column-display = "tabbed";

      tab-indicator = {
        position = "top";
        gaps-between-tabs = 10;

        # hide-when-single-tab = true;
        # place-within-column = true;

        # active.color = "red";
      };

    };
    outputs = builtins.listToAttrs (
      map (m: {
        inherit (m) name;
        value = with m; {
          enable = enabled;
          background-color = "#000000";
          mode = {
            inherit width;
            inherit height;
            refresh = refreshRate;
          };
          position = {
            inherit x;
            inherit y;
          };
          inherit scale;
        };

      }) config.monitors
    );
    environment = {
      DISPLAY = ":0";
    };
    spawn-at-startup =
      let
        get-wayland-display = "systemctl --user show-environment | awk -F 'WAYLAND_DISPLAY=' '{print $2}' | awk NF";
        wrapper =
          name: op:
          pkgs.writeScript "${name}" ''
            if [ "$(${get-wayland-display})" ${op} "$WAYLAND_DISPLAY" ]; then
              exec "$@"
            fi
          '';

        only-without-session = wrapper "only-without-session" "!=";
      in
      [
        {
          command = [
            "${only-without-session}"
            (lib.getExe pkgs.waybar)
          ];
        }
        {
          command = [
            "${only-without-session}"
            (lib.getExe pkgs.albert)
          ];
        }
        {
          command = [
            "${only-without-session}"
            (lib.getExe pkgs.hypridle)
          ];
        }
        {
          command = [
            "${only-without-session}"
            (lib.getExe' pkgs.swaynotificationcenter "swaync")
          ];
        }
        {
          command = [
            (lib.getExe pkgs.xwayland-satellite)
          ];
        }
        {
          command = [
            (lib.getExe' pkgs.nextcloud-client "nextcloud")
          ];
        }
        {
          command = [
            (lib.getExe pkgs.copyq)
          ];
        }
      ];
  };
}
