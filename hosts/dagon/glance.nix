{
  lib,
  config,
  ...
}:
let
  host = "localhost";
  port = 4321;
in
{

  users.users.glance = {
    isSystemUser = true;
    group = "glance";
  };
  users.groups.glance = { };
  sops.secrets = {
    glance-secret-key = {
      sopsFile = ../common/secrets.yaml;
      owner = "glance";
    };
    glance-password = {
      sopsFile = ../common/secrets.yaml;
      owner = "glance";
    };
  };
  systemd.services.glance = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "glance";
      Group = "glance";
    };
  };

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
        auth = {
          secret-key = {
            _secret = config.sops.secrets.glance-secret-key.path;
          };
          users = {
            admin.password = {
              _secret = config.sops.secrets.glance-password.path;
            };
          };
        };
        server = {
          inherit host port;
          proxied = true;
        };
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
                    location = "Lille, France";
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
                            title = "Jellyfin";
                            url = "https://jellyfin.louis-thevenet.fr";
                            icon = "si:spotify";
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
                      {
                        title = "Karakeep";
                        url = "https://karakeep.louis-thevenet.fr";
                      }
                      {
                        title = "Jellyfin";
                        url = "https://jellyfin.louis-thevenet.fr";
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
                        };
                      }
                    ];
                  }
                ];
              }
              {
                size = "full";
                widgets =
                  let
                    collapse-after = 15;
                  in
                  [
                    {
                      type = "group";
                      widgets = [
                        # {
                        #   title = "LW (broken?)";
                        #   type = "rss";
                        #   style = "vertical-list";
                        #   # https://github.com/glanceapp/glance/blob/main/docs/configuration.md#style
                        #   inherit collapse-after;
                        #   feeds = [
                        #     {
                        #       url = "http://www.lesswrong.com/feed.xml?view=curated-rss";
                        #       title = "LessWrong";
                        #     }
                        #   ];
                        #{
                        {
                          title = "Indie Blogs";
                          type = "rss";
                          style = "vertical-list";
                          inherit collapse-after;
                          feeds = [
                            {
                              url = "https://zythom.fr/feed/";
                              title = "Zythom";
                            }
                            {
                              url = "https://skybert.net/feeds/atom-feed.xml";
                              title = "Skybert";
                            }
                            {
                              url = "https://feeds.feedburner.com/ThePragmaticEngineer";
                              title = "ThePragmaticEngineer";
                            }
                            {
                              url = "https://boehs.org/in/blog.xml";
                              title = "Evan Boehs";
                            }
                            {
                              url = "https://terminaltrove.com/blog.xml";
                              title = "Terminal Trove";
                            }
                            {
                              url = "https://vin01.github.io/piptagole";
                              title = "Vin01";
                            }
                            {
                              url = "https://vin01.github.io/piptagole";
                              title = "Schneier on Security";
                            }
                            {
                              url = "https://lcamtuf.substack.com/feed";
                              title = "lcamtuf’s thing";
                            }
                            {
                              url = "https://michaelnielsen.org/ddi/rss";
                              title = "DDI Data-driven intelligence";
                            }
                            {
                              url = "https://alexanderobenauer.com/assets/feed/rss.xml";
                              title = "Alexander Obenauer";
                            }
                            {
                              url = "https://drewdevault.com/blog/index.xml";
                              title = "Drew DeVault's blog";
                            }
                            {
                              url = "https://ciechanow.ski/atom.xml";
                              title = "Bartosz Ciechanowski";
                            }
                            {
                              url = "https://www.copetti.org/index.xml";
                              title = "The Copetti site";
                            }
                            {
                              url = "file:///home/louis/Downloads/feed.xml";
                              title = "Taylor Troesh 🐸";
                            }
                            {
                              url = "https://benjaminhollon.com/musings/feed/";
                              title = "benjaminhollon Musings";
                            }
                            {
                              url = "https://tty1.blog/feed/";
                              title = "benjaminhollon TTY1";
                            }
                            {
                              url = "https://arun.is/rss.xml";
                              title = "Arun";
                            }
                            {
                              url = "http://www.julian.digital/feed";
                              title = "Julian digital";
                            }
                            {
                              url = "https://axleos.com/blog/index.xml";
                              title = "Axleos";
                            }
                            {
                              url = "https://xeiaso.net/blog.rss";
                              title = "Xe Iaso";
                            }
                            {
                              url = "https://manuelmoreale.com/feed";
                              title = "P&B";
                            }
                            {
                              url = "https://uncenter.dev/feed.xml";
                              title = "uncenter";
                            }
                            {
                              url = "https://matklad.github.io/feed";
                              title = "matklad";
                            }
                            {
                              url = "https://slightknack.dev/atom.xml";
                              title = "SlightKnack";
                            }
                            {
                              url = "https://site.sebasmonia.com/feed.xml";
                              title = "sebasmonia";
                            }
                            {
                              url = "https://milofultz.com/rss.xml";
                              title = "milofutz";
                            }
                            {
                              url = "https://milofultz.com/rss.xml";
                              title = "milofutz";
                            }
                            {
                              url = "https://milofultz.com/bookmarks.rss";
                              title = "milofutz's bookmarks";
                            }
                            {
                              url = "https://akselmo.dev/feed.xml";
                              title = "Akselmo";
                            }
                            {
                              url = "https://initcoder.com/feed.xml";
                              title = "InitCoder";
                            }

                          ];
                        }
                        {
                          type = "hacker-news";
                          inherit collapse-after;
                        }
                        {
                          type = "lobsters";
                          inherit collapse-after;
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

                        {
                          title = "Simon Willison";
                          type = "rss";
                          style = "vertical-list";
                          inherit collapse-after;
                          feeds = [
                            {
                              url = "https://simonwillison.net/atom/everything/";
                              title = "Simon Willison";
                            }
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
            name = "Github";
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "releases";
                    collapse-after = 999;
                    # Some stuff I need to keep track of (mostly the package I maintain in nixpkgs)
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
