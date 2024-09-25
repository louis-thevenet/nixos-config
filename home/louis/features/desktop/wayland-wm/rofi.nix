{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.desktop;
  cliphist-rofi-img = ".config/rofi/cliphist-rofi-img";
in {
  home.file.${cliphist-rofi-img} = {
    text = ''
        #!/usr/bin/env bash

      tmp_dir="/tmp/cliphist"
      rm -rf "$tmp_dir"

      if [[ -n "$1" ]]; then
          cliphist decode <<<"$1" | wl-copy
          exit
      fi

      mkdir -p "$tmp_dir"

      read -r -d \'\' prog <<EOF
      /^[0-9]+\s<meta http-equiv=/ { next }
      match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
          system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
          print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
          next
      }
      1
      EOF
      cliphist list | gawk "$prog"
    '';
    executable = true;
  };
  programs.rofi = mkIf cfg.hyprland.enable {
    enable = true;
    package = pkgs.rofi-wayland;

    plugins = [
    ];
    terminal = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      modi = "drun,filebrowser,ssh";
      show-icons = true;
      display-drun = "🔍 Apps";
      display-run = "🔧 Run";
      display-filebrowser = "📂 Files";
      display-ssh = "🔑 SSH";
      dpi = 1;
    };

    theme = let
      # Use `mkLiteral` for string-like values that should show without
      # quotes, e.g.:
      # {
      #   foo = "abc"; =&gt; foo: "abc";
      #   bar = mkLiteral "abc"; =&gt; bar: abc;
      # };
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      "window" = {
        width = mkLiteral "30%";
        height = mkLiteral "70%";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        padding = mkLiteral "5px";

        border = mkLiteral "2px";
        border-radius = mkLiteral "6px";
      };

      "inputbar" = {
        spacing = mkLiteral "0px";
        padding = mkLiteral "3px";
        children = mkLiteral ''[ "entry","num-filtered-rows","textbox-num-sep","num-rows" ]'';
      };

      "num-filtered-rows" = {
        expand = false;
        text-color = mkLiteral "Gray";
      };

      "textbox-num-sep" = {
        expand = false;
        str = "/";
        text-color = mkLiteral "Gray";
      };

      "num-rows" = {
        expand = false;
        text-color = mkLiteral "Gray";
      };

      "entry, element-icon, element-text" = {
        vertical-align = mkLiteral "0.5";
      };

      "textbox" = {
        padding = mkLiteral "4px 8px";
      };

      "listview" = {
        padding = mkLiteral "4px 0px";
        columns = 1;
        scrollbar = true;
      };

      "element" = {
        padding = mkLiteral "4px 8px";
        spacing = mkLiteral "8px";
      };

      "element-icon" = {
        size = mkLiteral "2em";
      };

      "element-text" = {
        text-color = mkLiteral "inherit";
      };

      "scrollbar" = {
        handle-width = mkLiteral "4px";
        padding = mkLiteral "0 4px";
      };

      "sidebar" = {
        "border" = mkLiteral "2px dash 0px 0px";
      };

      "button" = {
        cursor = "pointer";
        spacing = 0;
      };
    };
  };
}
