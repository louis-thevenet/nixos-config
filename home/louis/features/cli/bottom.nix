{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.cli;
  cfg-stylix = config.home-config.desktop.stylix;
in
{
  programs.bottom = mkIf cfg.commonTools.enable {
    enable = true;
    settings = {
      # from <https://github.com/guifuentes8/nix-config/blob/main/home/global/interfaces/WM/shared/pkgs/bottom/default.nix>
      colors =
        with config.lib.stylix.colors;
        mkIf cfg-stylix.enable {
          table_header_color = "#${base06}";
          all_cpu_color = "#${base06}";
          avg_cpu_color = "#${base0F}";
          cpu_core_colors = [
            "#${base08}"
            "#${base09}"
            "#${base0A}"
            "#${base0B}"
            "#${base0D}"
            "#${base0E}"
          ];
          ram_color = "#${base0B}";
          swap_color = "#${base09}";
          rx_color = "#${base0B}";
          tx_color = "#${base08}";
          widget_title_color = "#${base06}";
          border_color = "#${base01}";
          highlighted_border_color = "#${base0F}";
          text_color = "#${base05}";
          graph_color = "#${base04}";
          cursor_color = "#${base0F}";
          selected_text_color = "#${base02}";
          selected_bg_color = "#${base0E}";
          high_battery_color = "#${base0B}";
          medium_battery_color = "#${base0A}";
          low_battery_color = "#${base08}";
          gpu_core_colors = [
            "#${base0D}"
            "#${base0E}"
            "#${base08}"
            "#${base09}"
            "#${base0A}"
            "#${base0B}"
          ];
          arc_color = "#${base0C}";
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
