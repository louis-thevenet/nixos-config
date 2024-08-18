{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in {
  imports = [inputs.schizofox.homeManagerModule];
  programs.schizofox = let
    inherit (config.lib.stylix) colors;
  in
    mkIf cfg.schizofox.enable {
      enable = true;

      theme = {
        colors = {
          background-darker = "${colors.base01}";
          background = "${colors.base00}";
          foreground = "${colors.base05}";
        };

        font = "Lexend";

        extraUserChrome = ''
          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
              display: none;
          }

          body {
              color: red !important;
          }

          #TabsToolbar {
              visibility: collapse !important;
          }

        '';
      };

      search = {
        defaultSearchEngine = "Searx";

        removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];

        searxUrl = cfg.schizofox.searxngInstance;
        searxQuery = cfg.schizofox.searxngInstance + "/search?q={searchTerms}&categories=general";
        addEngines = [
          {
            Name = "nixpkgs";
            Description = "Nixpkgs query";
            Alias = "!pkg";
            Method = "GET";
            URLTemplate = "https://search.nixos.org/packages?&query={searchTerms}";
          }
          {
            Name = "mynixos";
            Description = "MyNixOS query";
            Alias = "!nix";
            Method = "GET";
            URLTemplate = "https://mynixos.com/search?q={searchTerms}";
          }

          {
            Name = "GitHub Repos";
            Description = "Search GitHub repositories";
            Alias = "!gh";
            Method = "GET";
            URLTemplate = "https://github.com/search?q={searchTerms}&type=repositories";
          }
          {
            Name = "Moodle N7";
            Description = "Search ENSEEIHT's moodle";
            Alias = "!n7";
            Method = "GET";
            URLTemplate = "https://moodle-n7.inp-toulouse.fr/course/search.php?context=1&q={searchTerms}";
          }
        ];
      };

      security = {
        sanitizeOnShutdown = false;
        sandbox = true;
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:106.0) Gecko/20100101 Firefox/106.0";
        enableCaptivePortal = true;
      };

      extensions = {
        enableDefaultExtensions = true;
        darkreader.enable = true;
        enableExtraExtensions = true;
        extraExtensions = {
          "cb-remover@search.mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clickbait-remover-for-youtube/latest.xpi";
          "treestyletab@piro.sakura.ne.jp".install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";

          "{74145f27-f039-47ce-a470-a662b129930a}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          "{b86e4813-687a-43e6-ab65-0bde4ab75758}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn-fork-of-decentraleyes/latest.xpi";
          "DontFuckWithPaste@raim.ist".install_url = "https://addons.mozilla.org/firefox/downloads/latest/don-t-fuck-with-paste/latest.xpi";
          "{531906d3-e22f-4a6c-a102-8057b88a1a63}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi";
          "skipredirect@sblask".install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
          "smart-referer@meh.paranoid.pk".install_url = "https://addons.mozilla.org/firefox/downloads/latest/smart-referer/latest.xpi";
          "7esoorv3@alefvanoon.anonaddy.me".install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";

          "{addons@wakatime.com}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/wakatime/latest.xpi";
            installation_mode = "force_installed";
          };

          "{b43b974b-1d3a-4232-b226-eaa2ac6ebb69}" = {
            # Random User-Agent Switcher
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/random_user_agent/latest.xpi";
            installation_mode = "force_installed";
          };

          "{6fb452f2-75ff-468c-b383-aa422688fc64}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/pageassist/latest.xpi";

          "jid0-3GUEt1r69sQNSrca5p8kx9Ezc3U@jetpack" = {
            # Terms of Service, Didn't Read
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/tosdr_browser_extension/latest.xpi";
          };
          "sponsorBlocker@ajay.app" = {
            # Sponsor Block
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          };
        };
      };

      misc = {
        displayBookmarksInToolbar = "newtab";
        drm.enable = true;
        disableWebgl = false;
        contextMenu.enable = true;
        bookmarks = [
          {
            Title = "GitHub";
            URL = "https://github.com/dashboard";
            Placement = "toolbar";
          }
          {
            Title = "Gmail";
            URL = "https://mail.google.com/mail/u/0/?hl=fr#inbox";
            Placement = "toolbar";
          }
          {
            Title = "Proton";
            URL = "https://mail.proton.me/u/0/inbox";
            Placement = "toolbar";
          }

          {
            Title = "DailyDev";
            URL = "https://app.daily.dev/";
            Placement = "toolbar";
          }

          # N7
          {
            Title = "Planète";
            URL = "http://planete.inp-toulouse.fr";
            Placement = "toolbar";
            Folder = "N7";
          }
          {
            Title = "Moodle";
            URL = "https://moodle-n7.inp-toulouse.fr/";
            Placement = "toolbar";
            Folder = "N7";
          }

          {
            Title = "GitHub N7";
            URL = "https://github.com/A-delta/N7";
            Placement = "toolbar";
            Folder = "N7";
          }
          {
            Title = "Hudson";
            URL = "https://hudson.inp-toulouse.fr/";
            Placement = "toolbar";
            Folder = "N7";
          }
          {
            Title = "Churros";
            URL = "https://churros.inpt.fr/";
            Placement = "toolbar";
            Folder = "N7";
          }

          # NextCloud
          {
            Title = "Dashboard";
            URL = "https://nextcloud.louis-thevenet.fr/index.php/apps/dashboard/#/";
            Folder = "NC";
            Placement = "toolbar";
          }
          {
            Title = "News";
            URL = "https://nextcloud.louis-thevenet.fr/index.php/apps/news/";
            Folder = "NC";
            Placement = "toolbar";
          }
          {
            Title = "Files";
            URL = "https://nextcloud.louis-thevenet.fr/index.php/apps/files/files";
            Folder = "NC";
            Placement = "toolbar";
          }

          # Nix
          {
            Title = "Packages";
            URL = "https://search.nixos.org/packages";
            Placement = "toolbar";
            Folder = "Nix";
          }
          {
            Title = "My NixOS";
            URL = "https://mynixos.com/";
            Placement = "toolbar";
            Folder = "Nix";
          }
          {
            Title = "HomeManager options";
            URL = "https://mynixos.com/home-manager/options";
            Placement = "toolbar";
            Folder = "Nix";
          }

          # Typst
          {
            Title = "Typst";
            URL = "https://typst/app.com/";
            Placement = "toolbar";
            Folder = "Typst";
          }
          {
            Title = "Docs";
            URL = "https://typst.app/docs/";
            Placement = "toolbar";
            Folder = "Typst";
          }
          {
            Title = "Project Euler";
            URL = "https://projecteuler.net/archives";
            Placement = "toolbar";
          }

          # DnD
          {
            Title = "Thorgar";
            URL = "https://www.aidedd.org/dnd-builder/sheetScreen.php?id=273072";
            Placement = "toolbar";
            Folder = "DnD";
          }
          {
            Title = "Spells";
            URL = "https://www.aidedd.org/dnd-filters/sorts.php";
            Placement = "toolbar";
            Folder = "DnD";
          }
        ];
      };
    };
}
