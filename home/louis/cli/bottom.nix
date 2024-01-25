{config, ...}: {
  programs.bottom = {
    enable = true;
    settings = {
      # from <https://github.com/guifuentes8/nix-config/blob/main/home/global/interfaces/WM/shared/pkgs/bottom/default.nix>
      colors = with config.colorScheme; {
        table_header_color = "#${colors.base06}";
        all_cpu_color = "#${colors.base06}";
        avg_cpu_color = "#${colors.base0F}";
        cpu_core_colors = ["#${colors.base08}" "#${colors.base09}" "#${colors.base0A}" "#${colors.base0B}" "#${colors.base0D}" "#${colors.base0E}"];
        ram_color = "#${colors.base0B}";
        swap_color = "#${colors.base09}";
        rx_color = "#${colors.base0B}";
        tx_color = "#${colors.base08}";
        widget_title_color = "#${colors.base06}";
        border_color = "#${colors.base01}";
        highlighted_border_color = "#${colors.base0F}";
        text_color = "#${colors.base05}";
        graph_color = "#${colors.base04}";
        cursor_color = "#${colors.base0F}";
        selected_text_color = "#${colors.base02}";
        selected_bg_color = "#${colors.base0E}";
        high_battery_color = "#${colors.base0B}";
        medium_battery_color = "#${colors.base0A}";
        low_battery_color = "#${colors.base08}";
        gpu_core_colors = ["#${colors.base0D}" "#${colors.base0E}" "#${colors.base08}" "#${colors.base09}" "#${colors.base0A}" "#${colors.base0B}"];
        arc_color = "#${colors.base0C}";
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
