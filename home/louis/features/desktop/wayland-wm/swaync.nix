{
  config,
  lib,
  pkgs,
  stylix,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
in
  with config.colorscheme.colors; let
    background = "#" + base00;
    altBackground = "#" + base01;
    selBackground = "#" + base03;
    text = "#" + base05;
    altText = "#" + base04;
    warning = "#" + base0A;
    urgent = "#" + base09;
    error = "#" + base08;
    focused = "#" + base0A;
    unfocused = "#" + base03;
    boarder = "#" + base0D;

    fonts = {
      names = [config.fontProfiles.monospace.family];
      size =
        config
        .stylix
        .fonts
        .sizes
        .desktop
        + 0.0;
    };
    #colors = config.lib.stylix.colors.withHashtag;
    opacity = lib.toHexString (((builtins.ceil (config.stylix.opacity.popups * 100)) * 255) / 100);
  in {
    home.packages = mkIf cfg.hyprland.enable (with pkgs; [
      swaynotificationcenter
    ]);

    # man 5 swaync
    home.file.".config/swaync/config.json".text = ''
      {
        "positionX": "right",
        "positionY": "top",
        "layer": "overlay",
        "control-center-layer": "top",
        "layer-shell": true,
        "cssPriority": "application",
        "control-center-margin-top": 0,
        "control-center-margin-bottom": 0,
        "control-center-margin-right": 0,
        "control-center-margin-left": 0,
        "notification-2fa-action": true,
        "notification-inline-replies": true,
        "notification-icon-size": 64,
        "notification-body-image-height": 100,
        "notification-body-image-width": 200,
        "timeout": 10,
        "timeout-low": 5,
        "timeout-critical": 0,
        "fit-to-screen": true,
        "relative-timestamps": true,
        "control-center-width": 500,
        "control-center-height": 600,
        "notification-window-width": 500,
        "keyboard-shortcuts": true,
        "image-visibility": "when-available",
        "transition-time": 200,
        "hide-on-clear": true,
        "hide-on-action": true,
        "script-fail-notify": true,

        "notification-visibility": {
          "sonixd": {
            "state": "muted",
            "urgency": "Low",
            "app-name": "Sonixd"
          }
        },
        "widgets": [
          "inhibitors",
          "title",
          "volume",
          "buttons-grid",
          "dnd",
          "notifications"
        ],
        "widget-config": {
          "inhibitors": {
            "text": "Inhibitors",
            "button-text": "Clear All",
            "clear-all-button": true
          },
          "title": {
            "text": "",
            "clear-all-button": true,
            "button-text": "󰆴 Clear All"
          },
          "dnd": {
            "text": ""
          },
          "volume": {
              "show-per-app": true,
              "show-per-app-label": true
          },
          "buttons-grid": {
            "actions": [
                {
                    "label": "󰌾",
                    "command": "${pkgs.swaylock-effects}/bin/swaylock"
                },
                {
                    "label": "󰍃",
                    "command": "${pkgs.wlogout}/bin/wlogout"
                },
                {
                    "label": "󰕾",
                    "command": "${pkgs.ponymix}/bin/ponymix toggle"
                },
                {
                    "label": "󰖩",
                    "command": "${pkgs.alacritty}/bin/alacritty -e ${pkgs.networkmanager}/bin/nmtui"
                },
                {
                    "label": "󰂯",
                    "command": "${pkgs.blueman}/bin/blueman-manager"
                }
            ]
          }
        }
      }
    '';

    home.file.".config/swaync/style.css".text = let
      inherit (config.colorscheme) colors;
    in ''
      @define-color ${background};

      @define-color noti-border-color ${boarder};
      @define-color noti-bg ${background};
      @define-color noti-bg-darker ${background};
      @define-color noti-bg-hover ${selBackground};
      @define-color noti-bg-focus ${selBackground};
      @define-color noti-close-bg  ${background};
      @define-color noti-close-bg-hover  ${background};

      @define-color text-color ${text};
      @define-color text-color-disabled ${text};

      @define-color bg-selected ${selBackground};

      .notification-row {
        outline: none;
      }

      .notification-row:focus,
      .notification-row:hover {
        background: @noti-bg-focus;
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;

        padding: 0;
      }

      /* Uncomment to enable specific urgency colors
      .low {
        background: yellow;
        padding: 6px;
        border-radius: 12px;
      }

      .normal {
        background: {};
        padding: 6px;
        border-radius: 12px;
      }
      */

      .critical {
        background: ${urgent};
        padding: 6px;
        border-radius: 12px;
      }

      .notification-content {
        background: transparent;
        padding: 6px;
        border-radius: 12px;
      }

      .close-button {
        background: @noti-close-bg;
        color: @text-color;
        text-shadow: none;
        padding: 0;
        border-radius: 100%;
        margin-top: 10px;
        margin-right: 16px;
        box-shadow: none;
        border: none;
        min-width: 24px;
        min-height: 24px;
      }

      .close-button:hover {
        box-shadow: none;
        background: @noti-close-bg-hover;
        transition: all 0.15s ease-in-out;
        border: none;
      }

      .notification-default-action,
      .notification-action {
        padding: 4px;
        margin: 0;
        box-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        color: @text-color;
        transition: all 0.15s ease-in-out;
      }

      .notification-default-action:hover,
      .notification-action:hover {
        -gtk-icon-effect: none;
        background: @noti-bg-hover;
      }

      .notification-default-action {
        border-radius: 12px;
      }

      /* When alternative actions are visible */
      .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
      }

      .notification-action {
        border-radius: 0px;
        border-top: none;
        border-right: none;
      }

      /* add bottom border radius to eliminate clipping */
      .notification-action:first-child {
        border-bottom-left-radius: 10px;
      }

      .notification-action:last-child {
        border-bottom-right-radius: 10px;
        border-right: 1px solid @noti-border-color;
      }

      .inline-reply {
        margin-top: 8px;
      }
      .inline-reply-entry {
        background: @noti-bg-darker;
        color: @text-color;
        caret-color: @text-color;
        border: 1px solid @noti-border-color;
        border-radius: 12px;
      }
      .inline-reply-button {
        margin-left: 4px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        border-radius: 12px;
        color: @text-color;
      }
      .inline-reply-button:disabled {
        background: initial;
        color: @text-color-disabled;
        border: 1px solid transparent;
      }
      .inline-reply-button:hover {
        background: @noti-bg-hover;
      }

      .image {
      }

      .body-image {
        margin-top: 6px;
        background-color: white;
        border-radius: 12px;
      }

      .summary {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }

      .time {
        font-size: 16px;
        font-weight: bold;
        background: transparent;
        color: @text-color;
        text-shadow: none;
        margin-right: 18px;
      }

      .body {
        font-size: 15px;
        font-weight: normal;
        background: transparent;
        color: @text-color;
        text-shadow: none;
      }

      .control-center {
        background: transparent;
      }

      .control-center-list {
        background: transparent;
      }

      .control-center-list-placeholder {
        opacity: 0.5;
      }

      .floating-notifications {
        background: transparent;
      }

      /* Window behind control center and on all other monitors */
      .blank-window {
        background: alpha(black, 0.25);
      }

      /*** Widgets ***/

      /* Title widget */
      .widget-title {
        margin: 8px;
        font-size: 1.5rem;
      }
      .widget-title > button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }
      .widget-title > button:hover {
        background: @noti-bg-hover;
      }

      /* DND widget */
      .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
      }
      .widget-dnd > switch {
        font-size: initial;
        border-radius: 12px;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
      }
      .widget-dnd > switch:checked {
        background: @bg-selected;
      }
      .widget-dnd > switch slider {
        background: @noti-bg-hover;
        border-radius: 12px;
      }

      /* Label widget */
      .widget-label {
        margin: 8px;
      }
      .widget-label > label {
        font-size: 1.1rem;
      }

      /* Mpris widget */
      .widget-mpris {
        /* The parent to all players */
      }
      .widget-mpris-player {
        padding: 8px;
        margin: 8px;
      }
      .widget-mpris-title {
        font-weight: bold;
        font-size: 1.25rem;
      }
      .widget-mpris-subtitle {
        font-size: 1.1rem;
      }

      /* Buttons widget */
      .widget-buttons-grid {
        font-size: x-large;
        padding: 5px;
        margin: 10px 10px 5px 10px;
        border-radius: 5px;
        background-color: @noti-bg;
      }

      .widget-buttons-grid>flowbox>flowboxchild>button{
        background: @noti-bg;
        border-radius: 12px;
      }

      /* style given to the active toggle button */
      .widget-buttons-grid>flowbox>flowboxchild>button.toggle:checked {
      }

      .widget-buttons-grid>flowbox>flowboxchild>button:hover {
      }

      /* Menubar widget */
      .widget-menubar>box>.menu-button-bar>button {
        border: none;
        background: transparent;
      }

      /* .AnyName { Name defined in config after #
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .AnyName>button {
        background: transparent;
        border: none;
      }

      .AnyName>button:hover {
        background-color: @noti-bg-hover;
      } */

      .topbar-buttons>button { /* Name defined in config after # */
        border: none;
        background: transparent;
      }

      /* Volume widget */

      .widget-volume {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      .widget-volume>box>button {
        background: transparent;
        border: none;
      }

      .per-app-volume {
        background-color: @noti-bg-alt;
        padding: 4px 8px 8px 8px;
        margin: 0px 8px 8px 8px;
        border-radius: 12px;
      }

      /* Backlight widget */
      .widget-backlight {
        background-color: @noti-bg;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }

      /* Title widget */
      .widget-inhibitors {
        margin: 8px;
        font-size: 1.5rem;
      }
      .widget-inhibitors > button {
        font-size: initial;
        color: @text-color;
        text-shadow: none;
        background: @noti-bg;
        border: 1px solid @noti-border-color;
        box-shadow: none;
        border-radius: 12px;
      }
      .widget-inhibitors > button:hover {
        background: @noti-bg-hover;
      }
    '';
  }
