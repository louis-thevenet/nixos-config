{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in
{
  programs.kitty = mkIf cfg.kitty.enable {
    enable = true;
    theme = "Solarized Light";
    settings = {
      scrollback_lines = 4000;
      scrollback_pager_history_size = 2048;
      window_padding_width = 15;
    };
  };
}
