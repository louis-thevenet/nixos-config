{ lib, config, ... }:
let
  host = "localhost";
  port = 4321;
in
{

  networking.firewall.allowedTCPPorts = [
    port
  ];
  services = {
    anubis.instances.glance.settings.TARGET = "http://${host}:${toString port}";
    nginx.virtualHosts."db.louis-thevenet.fr" = {
      forceSSL = true;
      enableACME = true; # automatic Let's Encrypt
      locations = {
        "/".proxyPass = "http://unix:${config.services.anubis.instances.glance.settings.BIND}";
        "/".extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    glance = {
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
                  {
                    type = "monitor";
                    cache = "1m";
                    title = "Services";
                    sites = [
                      {
                        title = "Nextcloud";
                        url = "https://nc.louis-thevenet.fr";
                      }
                    ];
                  }
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "Server";
                        mountpoints = {
                          "/" = {
                            name = "Server";
                          };
                          "/nextcloud_data" = {
                            name = "NextCloud Storage";
                          };
                        };
                      }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
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
                  { type = "calendar-legacy"; }
                  {
                    type = "markets";
                    markets = [
                      {
                        symbol = "CW8.PA";
                        name = "Amundi MSCI World UCITS ETF C";
                        symbol-link = "https://finance.yahoo.com/quote/CW8.PA";
                      }
                    ];

                  }
                ];
              }
            ];
          }
          {
            name = "Videos";
            columns = [
              {
                size = "full";
                widgets = lib.map (
                  { name, value }:
                  {
                    type = "videos";
                    title = name;
                    channels = lib.catAttrs "url" value.channels;
                  }
                ) (lib.attrsToList (builtins.fromTOML (builtins.readFile /home/louis/Nextcloud/yt_channels.toml)));
              }
            ];
          }
          {
            name = "Github";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "releases";
                    collapse-after = 999;
                    repositories = [
                      "Skardyy/mcat"
                      "bodo-run/yek"
                      "alexpasmantier/television"
                      "Thumuss/utpm"
                      "louis-thevenet/vault-tasks"
                      "nik-rev/patchy"
                      "guilhermeprokisch/see"
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "repository";
                    repository = "louis-thevenet/vault-tasks";
                    pull-requests-limit = 5;
                    issues-limit = 5;
                    commits-limit = 5;
                  }
                  {
                    type = "repository";
                    repository = "louis-thevenet/N7";
                    pull-requests-limit = 5;
                    issues-limit = 5;
                    commits-limit = 5;
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
