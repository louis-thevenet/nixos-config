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
      (pkgs.callPackage
        ./rofi-ollama
        {})

      (pkgs.callPackage
        ./rofi-vscode-mode
        {})
    ];
    terminal = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      modi = "drun,filebrowser,ssh,ollama,vscode-recent,clipboard:${cliphist-rofi-img}";
      show-icons = true;
      display-drun = "🔍 Apps";
      display-run = "🔧 Run";
      display-filebrowser = "📂 Files";
      display-ssh = "🔑 SSH";
      display-ollama = "🧠 Ollama";
      display-vscode-recent = "📂 VSCode Recent";
      display-clipboard = "Clipboard";
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
      inherit (config.colorscheme) palette;
    in {
      "*" = {
        bg0 = mkLiteral "#${palette.base00}";
        bg1 = mkLiteral "#${palette.base02}";
        fg0 = mkLiteral "#${palette.base05}";
        fg1 = mkLiteral "#${palette.base04}";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg0";

        margin = 0;
        padding = 0;
        spacing = 0;
      };

      # "element-icon, element-text, scrollbar" = {
      #   cursor = mkLiteral "pointer";
      # };

      "window" = {
        #location = mkLiteral "northwest";
        width = mkLiteral "50%";
        height = mkLiteral "50%";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        padding = mkLiteral "5px";

        background-color = mkLiteral "@bg0";
        border = mkLiteral "2px";
        border-color = mkLiteral "@bg1";
        border-radius = mkLiteral "6px";
      };

      "inputbar" = {
        spacing = mkLiteral "0px";
        padding = mkLiteral "3px";
        children = mkLiteral ''[ "entry","num-filtered-rows","textbox-num-sep","num-rows" ]'';
        background-color = mkLiteral "@bg0";
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
        background-color = mkLiteral "@bg0";
      };

      "listview" = {
        padding = mkLiteral "4px 0px";
        columns = 2;
        scrollbar = true;
      };

      "element" = {
        padding = mkLiteral "4px 8px";
        spacing = mkLiteral "8px";
      };

      "element normal urgent" = {
        text-color = mkLiteral "@fg1";
      };

      "element normal active" = {
        text-color = mkLiteral "@fg1";
      };

      "element selected" = {
        text-color = mkLiteral "@bg0"; #1
        background-color = mkLiteral "@fg1";
      };

      "element selected urgent" = {
        background-color = mkLiteral "@fg1";
      };

      "element-icon" = {
        size = mkLiteral "0.8em";
      };

      "element-text" = {
        text-color = mkLiteral "inherit";
      };

      "scrollbar" = {
        handle-width = mkLiteral "4px";
        handle-color = mkLiteral "@fg1";
        padding = mkLiteral "0 4px";
      };

      "sidebar" = {
        "border-color" = mkLiteral "@bg1";
        "border" = mkLiteral "2px dash 0px 0px";
      };

      "button" = {
        cursor = "pointer";
        spacing = 0;
        text-color = mkLiteral "@fg0";
      };
      "button selected" = {
        background-color = mkLiteral "@fg1";
        text-color = mkLiteral "@bg0";
      };
    };
  };
}
