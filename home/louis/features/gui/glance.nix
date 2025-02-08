{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.gui;
  inherit (cfg.glance) host;
  inherit (cfg.glance) port;

in

{
  services.glance = mkIf cfg.glance.enable {
    enable = true;
    settings = {
      server = { inherit host port; };
      branding = {
        hide-footer = true;
        # favicon-url = "";
        # logo-url = "";
      };
      pages = [
        {
          name = "Home";
          # center-vertically = true;
          # hide-desktop-navigation = true;
          # width = "slim";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "weather";
                  units = "metric";
                  hour-format = "24h";
                  hide-location = false;
                  show-area-name = true;
                  location = "Toulouse, France";
                }
                {
                  type = "bookmarks"; # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#bookmarks
                  groups = [
                    {
                      title = "General";
                      links = [
                        {
                          title = "GitHub";
                          url = "https://github.com/dashboard";
                          icon = "si:github";
                        }
                        {
                          title = "Proton Mail";
                          url = "https://mail.proton.me/u/0/inbox";
                          icon = "si:proton";
                        }

                      ];
                    }
                    {
                      title = "N7";
                      links = [
                        {
                          title = "Moodle";
                          url = "https://moodle-n7.inp-toulouse.fr/course/index.php?categoryid=705";
                          icon = "si:moodle";
                        }
                        {
                          title = "Planète INP";
                          url = "http://planete.inp-toulouse.fr";
                          icon = "si:planet";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  autofocus = true;
                  search-engine = cfg.firefox.searxngInstance + "/search?q={QUERY}&categories=general";
                }
                {
                  type = "group";
                  widgets = [

                    {
                      type = "rss";
                      style = "vertical-list"; # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#style
                      collapse-after = 15;
                      feeds = [
                        {
                          url = "https://main--nixos-homepage.netlify.app/blog/announcements-rss.xml";
                          title = "NixOS";
                        }
                        {
                          url = "https://www.lesswrong.com/feed.xml?view=curated-rss";
                          title = "LessWrong";
                        }
                        {
                          url = "https://privacyinternational.org/rss.xml";
                          title = "PrivacyInternational";
                        }
                      ];
                    }
                    {
                      type = "hacker-news";
                      collapse-after = 15;
                    }
                    {
                      type = "lobsters";
                      collapse-after = 15;
                      sort-by = "hot";
                      tags = [
                        "ai"
                        "compsci"
                        "formalmethods"
                        "graphics"
                        "plt"
                        "programming"
                        "ml"
                        "rust"
                        "nix"
                        "privacy"
                        "vim"
                      ];
                    }
                  ];
                }
              ];
            }
            {
              size = "small";
              widgets = [
                { type = "calendar"; }
              ];
            }
          ];
        }
      ];
    };
  };
}
