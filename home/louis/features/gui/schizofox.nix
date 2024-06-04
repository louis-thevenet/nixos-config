{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
in {
  # imports = optionals cfg.enableSchizofox [inputs.schizofox.homeManagerModule];
  imports = [inputs.schizofox.homeManagerModule];
  programs.schizofox = let
    inherit (config.colorscheme) palette;
  in
    mkIf cfg.schizofox.enable {
      enable = true;

      theme = {
        colors = {
          background-darker = "${palette.base01}";
          background = "${palette.base00}";
          foreground = "${palette.base05}";
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
        darkreader.enable = false;
        simplefox.enable = true;
        extraExtensions = {
          "cb-remover@search.mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clickbait-remover-for-youtube/latest.xpi";
          "treestyletab@piro.sakura.ne.jp".install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}".install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
      };

      misc = {
        displayBookmarksInToolbar = "newtab";
        drm.enable = true;
        disableWebgl = false;
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
