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
    anubis.instances.glance.settings = {
      TARGET = "http://${host}:${toString port}";
      BIND = "/run/anubis/anubis-glance/anubis-glance.sock";
      METRICS_BIND = "/run/anubis/anubis-glance/anubis-glance-metrics.sock";
    };
    nginx.virtualHosts."db.ltvnt.com" = {
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
                    location = "Paris, France";
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
                            url = "https://jellyfin.ltvnt.com";
                            icon = "si:spotify";
                          }
                          {
                            title = "Firefly";
                            url = "https://firefly.ltvnt.com";
                            icon = "si:fireflyiii";
                          }
                          {
                            title = "Proton Mail";
                            url = "https://mail.proton.me/u/0/inbox";
                            icon = "si:proton";
                          }
                          {
                            title = "Hard Cover";
                            url = "https://hardcover.app/dashboard";
                            icon = "si:bookstack";
                          }

                        ];
                      }
                      {
                        title = "N7";
                        links = [
                          {
                            title = "Moodle";
                            url = "https://moodle.inp-toulouse.fr/login/index.php";
                            icon = "si:moodle";
                          }
                          {
                            title = "Planète INP";
                            url = "http://planete.inp-toulouse.fr";
                            icon = "si:planet";
                          }
                        ];
                      }
                      {
                        title = "ETS";
                        links = [
                          {
                            title = "Moodle";
                            url = "https://ena.etsmtl.ca/my/";
                            icon = "si:moodle";
                          }
                          {
                            title = "Mon ETS";
                            url = "https://portail.etsmtl.ca/home";
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
                        title = "Blog";
                        url = "https://blog.ltvnt.com";
                      }
                      {
                        title = "Nextcloud";
                        url = "https://nc.ltvnt.com";
                      }
                      {
                        title = "Firefly";
                        url = "https://firefly.ltvnt.com";
                      }
                      {
                        title = "Karakeep";
                        url = "https://karakeep.ltvnt.com";
                      }
                      {
                        title = "Jellyfin";
                        url = "https://jellyfin.ltvnt.com";
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
                            {
                              url = "https://parv.bearblog.dev/rss/";
                              title = "Parv";
                            }
                            {
                              url = "https://www.benkuhn.net/index.xml";
                              title = "Benkuhn";
                            }
                            {
                              url = "https://herman.bearblog.dev/feed/";
                              title = "Hermann BearBlog";
                            }
                            {
                              url = "https://tratt.net/laurie/blog/blog.rss";
                              title = "Laurie Tratt";
                            }
                            {
                              url = "https://dustri.org/b/rss.xml";
                              title = "Julien Voisin";
                            }
                            {
                              url = "https://www.benkuhn.net/rss";
                              title = "Ben Kuhn";
                            }
                            {
                              url = "https://emgoto.substack.com/feed";
                              title = "Emma Goto";
                            }
                            {
                              url = "https://localghost.dev/feed.xml";
                              title = "Local Ghost";
                            }
                            {
                              url = "https://www.vintagestory.at/forums/forum/7-news.xml/";
                              title = "Vintage Story Dev Blog";
                            }
                            {
                              url = "https://fromemily.com/feed/?type=rss";
                              title = "Emily Moran Barwick";
                            }
                            {
                              url = "https://www.davepagurek.com/rss.xml";
                              title = "Dave Pagurek";
                            }
                            {
                              url = "https://lunamouse.bearblog.dev/feed/?type=rss";
                              title = "Dear Luci";
                            }
                            {
                              url = "https://netigen.com/rss";
                              title = "Netigen";
                            }
                            {
                              url = "https://megancarnes.blog/feed/?type=rss/";
                              title = "Megan Carnes";
                            }
                            {
                              url = "https://localghost.dev/";
                              title = "Local Ghost";
                            }
                            {
                              url = "https://notes.jeddacp.com/feed/";
                              title = "JCProbably";
                            }
                            {
                              url = "https://graic.net/rss.xml";
                              title = "Graic";
                            }
                            {
                              url = "https://tadaima.bearblog.dev/rss/";
                              title = "Tadaima";
                            }
                            {
                              url = "https://writtenbywinter.bearblog.dev/rss/";
                              title = "Written By Winter";
                            }
                            {
                              url = "https://monocyte.bearblog.dev/feed/?q=blog";
                              title = "Monocyte";
                            }
                            {
                              url = "https://buttondown.com/dealgorithmed/rss";
                              title = "dealgorithmed";
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
                          title = "BearBlog Trending";
                          type = "rss";
                          style = "vertical-list";
                          inherit collapse-after;
                          feeds = [
                            {
                              url = "https://bearblog.dev/discover/feed/";
                              title = "BearBlog";
                            }
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
                    type = "custom-api";
                    title = "Day";
                    body-type = "string";
                    skip-json-validation = true;
                    cache = "1s";
                    template = ''
                      {{ $localTime := now }}
                      {{ $secondsPerDay := mul (sub 24 7) (mul 60 60) }} <!-- 7 hours of non-usable day -->
                      {{ $elapsedSeconds := sub (add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second) 25200 }}
                      {{ $dayProgress := div (mul $elapsedSeconds 100.0) $secondsPerDay }}

                      {{ $gradient := "" }}
                      {{ if lt $dayProgress 10.0 }}
                        {{ $gradient = "#70a1ff" }}
                      {{ else if lt $dayProgress 25.0 }}
                        {{ $gradient = "#ff6b6b, #70a1ff" }}
                      {{ else if lt $dayProgress 50.0 }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                      {{ else }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                      {{ end }}

                      <div style="font-family: sans-serif; text-align: center;">
                        <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                          <div style="
                            height: 100%;
                            width: {{ $dayProgress }}%;
                            background: linear-gradient(90deg, {{ $gradient }});
                          "></div>
                        </div>
                        <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $dayProgress }}% of usable day has passed</div>
                      </div>
                    '';
                  }

                  {
                    type = "custom-api";
                    title = "Month";
                    body-type = "string";
                    skip-json-validation = true;
                    cache = "1s";
                    template = ''
                      {{ $localTime := now }}

                      {{ $month := $localTime.Month }}
                      {{ $dayOfMonth := $localTime.Day }}

                      {{ $secondsToday := add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second }}
                      {{ $fractionOfDay := div $secondsToday 86400.0 }}

                      {{ $daysInMonth := 31 }}
                      {{ if eq $month 2 }} {{ $daysInMonth = 28 }} {{ end }}
                      {{ if or (eq $month 4) (eq $month 6) (eq $month 9) (eq $month 11) }} {{ $daysInMonth = 30 }} {{ end }}

                      {{ $daysElapsed := add (sub $dayOfMonth 1) $fractionOfDay }}
                      {{ $monthProgress := mul (div $daysElapsed $daysInMonth) 100.0 }}

                      {{ $gradient := "" }}
                      {{ if lt $monthProgress 10.0 }}
                        {{ $gradient = "#70a1ff" }}
                      {{ else if lt $monthProgress 25.0 }}
                        {{ $gradient = "#ff6b6b, #70a1ff" }}
                      {{ else if lt $monthProgress 50.0 }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                      {{ else }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                      {{ end }}

                      <div style="font-family: sans-serif; text-align: center;">
                        <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                          <div style="
                            height: 100%;
                            width: {{ $monthProgress }}%;
                            background: linear-gradient(90deg, {{ $gradient }});
                          "></div>
                        </div>
                        <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $monthProgress }}% of the month has passed</div>
                      </div>
                    '';
                  }
                  {
                    type = "custom-api";
                    title = "Year";
                    body-type = "string";
                    skip-json-validation = true;
                    cache = "1s";
                    template = ''
                      {{ $localTime := now }}

                      {{ $secondsToday := add (mul $localTime.Hour 3600) (mul $localTime.Minute 60) | add $localTime.Second }}
                      {{ $dayOfYear := $localTime.YearDay }}
                      {{ $secondsElapsed := add (mul (sub $dayOfYear 1) 86400) $secondsToday }}

                      {{ $totalSecondsInYear := mul 365 86400 }}
                      {{ $yearProgress := div (mul $secondsElapsed 100.0) $totalSecondsInYear }}

                      {{ $gradient := "" }}
                      {{ if lt $yearProgress 10.0 }}
                        {{ $gradient = "#70a1ff" }}
                      {{ else if lt $yearProgress 25.0 }}
                        {{ $gradient = "#ff6b6b, #70a1ff" }}
                      {{ else if lt $yearProgress 50.0 }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df" }}
                      {{ else }}
                        {{ $gradient = "#ff6b6b, #f8e71c, #7ed6df, #70a1ff" }}
                      {{ end }}

                      <div style="font-family: sans-serif; text-align: center;">
                        <div style="width: 100%; height: 12px; background: #23262F; border:1px solid gray; border-radius: 10px; overflow: hidden;">
                          <div style="
                            height: 100%;
                            width: {{ $yearProgress }}%;
                            background: linear-gradient(90deg, {{ $gradient }});
                          "></div>
                        </div>
                        <div class="size-h1" style="margin-top: 6px;">{{ printf "%.2f" $yearProgress }}% of the year has passed</div>
                      </div>
                    '';

                  }
                  {
                    type = "markets";
                    markets = [
                      {
                        symbol = "CW8.PA";
                        name = "Amundi MSCI World UCITS ETF C";
                        symbol-link = "https://finance.yahoo.com/quote/CW8.PA";
                      }
                      {
                        symbol = "PCEU.PA";
                        name = "Amundi MSCI Europe UCITS ETF C";
                        symbol-link = "https://finance.yahoo.com/quote/PCEU.PA";
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
                    include-shorts = false;
                    video-url-template = "https://inv.nadeko.net/{VIDEO-ID}";
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
