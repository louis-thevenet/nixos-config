{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in
{
  programs.beets = {
    enable = true;
    settings = {
      directory = "~/Nextcloud/music";
      library = "~/Nextcloud/musiclibrary.db";
      plugins = [
        "fetchart"
        "lyrics"
        "lastgenre"
        "embedart"
        "duplicates"
      ];
      lastgenre = {
        auto = true;
        source = "album";
      };
      terminal_encoding = "utf-8";
      original_date = true;
    };

  };
  home.packages = mkIf cfg.utils.enable (
    with pkgs;
    [
      calibre
      kdePackages.okular
      qimgv
      tor-browser-bundle-bin
      obs-studio
      spotifywm
    ]
  );
}
