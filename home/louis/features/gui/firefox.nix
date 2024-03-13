# This file is no longer imported in gui (see schizofox)
{
  config,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
  };
}
