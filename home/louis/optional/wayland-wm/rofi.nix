{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;

    plugins = [
      # pkgs.rofi-calc
      # pkgs.rofi-emoji
      (pkgs.callPackage
        ./rofi-ollama
        {})
    ];
    terminal = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      modi = "drun,filebrowser,window,ssh"; #,calc";
      show-icons = true;
      display-drun = "🔍 Apps";
      display-run = "🔧 Run";
      display-filebrowser = "📂 Files";
      display-window = "🪟 Windows";
      display-ssh = "🔑 SSH";
      #display-calc = "🟰 Calc";
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
      inherit (config.colorscheme) colors;
    in {
      "*" = {
        bg0 = mkLiteral "#${colors.base00}";
        bg1 = mkLiteral "#${colors.base02}";
        fg0 = mkLiteral "#${colors.base05}";
        fg1 = mkLiteral "#${colors.base04}";

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
        width = mkLiteral "30%";
        height = mkLiteral "30%";
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
