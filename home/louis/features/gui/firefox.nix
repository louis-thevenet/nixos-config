# This file is no longer imported in gui (see schizofox)
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
  plugins = inputs.firefox-addons.packages.${pkgs.system};
in
{
  programs.firefox = mkIf cfg.firefox.enable {
    enable = true;
    profiles.louis = {
      isDefault = true;
      settings = {

        "extensions.autoDisableScopes" = 0; # auto enable extensions
      }; # https://mynixos.com/home-manager/option/programs.firefox.profiles.%3Cname%3E.settings
      userChrome = ''
        #main-window #titlebar {
          overflow: hidden;
          transition: height 0.3s 0.3s !important;
        }
        /* Default state: Set initial height to enable animation */
        #main-window #titlebar { height: 3em !important; }
        #main-window[uidensity="touch"] #titlebar { height: 3.35em !important; }
        #main-window[uidensity="compact"] #titlebar { height: 2.7em !important; }
        /* Hidden state: Hide native tabs strip */
        #main-window[titlepreface*="XXX"] #titlebar { height: 0 !important; }
        /* Hidden state: Fix z-index of active pinned tabs */
        #main-window[titlepreface*="XXX"] #tabbrowser-tabs { z-index: 0 !important; }      '';
      extensions = with plugins; [
        privacy-badger
        darkreader
        ublock-origin
        refined-github
        enhanced-github
        clearurls
        adaptive-tab-bar-colour
        unpaywall

      ];
    };
  };
}
