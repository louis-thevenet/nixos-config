{
  config,
  inputs,
  ...
}: {
  imports = [inputs.schizofox.homeManagerModule];
  programs.schizofox = let
    inherit (config.colorscheme) colors;
  in {
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

      searxUrl = "searx.be";
      searxQuery = "https://searx.ox2.fr/search?q={searchTerms}&categories=general";
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
    };

    extensions = {
      darkreader.enable = false;
      simplefox.enable = true;
      extraExtensions = {
        "cb-remover@search.mozilla.org".install_url = "https://addons.mozilla.org/firefox/downloads/latest/clickbait-remover-for-youtube/latest.xpi";
        "treestyletab@piro.sakura.ne.jp".install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi";
        "ncpasswords@mdns.eu".install_url = "https://addons.mozilla.org/firefox/downloads/latest/nextcloud-passwords/latest.xpi";
      };
    };

    misc = {
      drmFix = true;
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
          Title = "Todoist";
          URL = "https://app.todoist.com/app/project/n7-2321454654";
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
          URL = "https://louis-thevenet.fr/nextcloud/index.php/apps/dashboard/#/";
          Folder = "NC";
          Placement = "toolbar";
        }
        {
          Title = "Passwords";
          URL = "https://louis-thevenet.fr/nextcloud/index.php/apps/passwords/";
          Folder = "NC";
          Placement = "toolbar";
        }
        {
          Title = "Mail";
          URL = "https://louis-thevenet.fr/nextcloud/index.php/apps/mail/";
          Folder = "NC";
          Placement = "toolbar";
        }
        {
          Title = "News";
          URL = "https://louis-thevenet.fr/nextcloud/index.php/apps/news/";
          Folder = "NC";
          Placement = "toolbar";
        }
        {
          Title = "Files";
          URL = "https://louis-thevenet.fr/nextcloud/index.php/apps/files/files";
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
