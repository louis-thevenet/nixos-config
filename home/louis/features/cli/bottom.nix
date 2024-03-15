{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
in {
  programs.bottom = mkIf cfg.commonTools.enable {
    enable = true;
    settings = {
      # from <https://github.com/guifuentes8/nix-config/blob/main/home/global/interfaces/WM/shared/pkgs/bottom/default.nix>
      colors = with config.colorScheme; {
        table_header_color = "#${palette.base06}";
        all_cpu_color = "#${palette.base06}";
        avg_cpu_color = "#${palette.base0F}";
        cpu_core_colors = ["#${palette.base08}" "#${palette.base09}" "#${palette.base0A}" "#${palette.base0B}" "#${palette.base0D}" "#${palette.base0E}"];
        ram_color = "#${palette.base0B}";
        swap_color = "#${palette.base09}";
        rx_color = "#${palette.base0B}";
        tx_color = "#${palette.base08}";
        widget_title_color = "#${palette.base06}";
        border_color = "#${palette.base01}";
        highlighted_border_color = "#${palette.base0F}";
        text_color = "#${palette.base05}";
        graph_color = "#${palette.base04}";
        cursor_color = "#${palette.base0F}";
        selected_text_color = "#${palette.base02}";
        selected_bg_color = "#${palette.base0E}";
        high_battery_color = "#${palette.base0B}";
        medium_battery_color = "#${palette.base0A}";
        low_battery_color = "#${palette.base08}";
        gpu_core_colors = ["#${palette.base0D}" "#${palette.base0E}" "#${palette.base08}" "#${palette.base09}" "#${palette.base0A}" "#${palette.base0B}"];
        arc_color = "#${palette.base0C}";
      };

      flags = {
        battery = true;
        color = "default-light";
        tree = true;
        enable_cache_memory = true;
      };
    };
  };
}
