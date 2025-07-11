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
  buildFirefoxXpiAddon = lib.makeOverridable (
    {
      src,
      pname,
      version,
      addonId,
      ...
    }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit src;

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = {
        inherit addonId;
      };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    }
  );
in
{
  stylix.targets.firefox.profileNames = [ "louis" ];
  programs.firefox = mkIf cfg.firefox.enable {
    enable = true;
    package = pkgs.firefox.override {
      nativeMessagingHosts = [
        # Tridactyl native connector
        pkgs.tridactyl-native
      ];
    };
    profiles.louis = {
      isDefault = true;
      search = {
        force = true;
        default = "SearxNG";
        privateDefault = "SearxNG";
        engines = {
          "SearxNG" = {
            urls = [
              {
                template =
                  cfg.firefox.searxngInstance.url
                  + ":"
                  + (toString cfg.firefox.searxngInstance.port)
                  + "/search?q={searchTerms}&categories=general";
              }
            ];
          };
          "MyNixOS" = {
            urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
            definedAliases = [ "@nix" ];
          };
          "Nixpkgs" = {
            urls = [ { template = "https://search.nixos.org/packages?&query={searchTerms}"; } ];
            definedAliases = [ "@pkg" ];
          };
          "Nixpkgs Pulls" = {
            urls = [
              { template = "https://github.com/NixOS/nixpkgs/pulls?q=is%3Apr+is%3Aopen+{searchTerms}"; }
            ];
            definedAliases = [ "@npp" ];
          };
          "GitHub Repos" = {
            urls = [ { template = "https://github.com/search?q={searchTerms}&type=repositories"; } ];
            definedAliases = [ "@gh" ];
          };
          "GitHub Code" = {
            urls = [ { template = "https://github.com/search?q={searchTerms}&type=code"; } ];
            definedAliases = [ "@gc" ];
          };
          "Karakeep" = {
            urls = [ { template = "https://karakeep.louis-thevenet.fr/dashboard/search?q={searchTerms}"; } ];
            definedAliases = [ "@kr" ];
          };
          bing.metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          wikipedia.metaData.hidden = true;
          "google".metaData.hidden = true;
          "ddg".metaData.hidden = true;
        };
      };
      userChrome = ''
        #TabsToolbar{ visibility: collapse !important }
      '';
      extensions.packages =
        with plugins;
        [
          adaptive-tab-bar-colour
          bitwarden
          clearurls
          darkreader
          enhanced-github
          privacy-badger
          refined-github
          terms-of-service-didnt-read
          tree-style-tab
          ublock-origin
          unpaywall
          batchcamp
          (limit-limit-distracting-sites.overrideAttrs { meta.license.free = true; })
          tridactyl
        ]
        ++ [
          (buildFirefoxXpiAddon rec {
            pname = "price_perspective";
            version = "1.1";
            file-number = "4466074";
            addonId = "priceperspective@drewdevault.com";
            src = pkgs.fetchurl {
              url = "https://addons.mozilla.org/firefox/downloads/file/${file-number}/${pname}-${version}.xpi";
              hash = "sha256-8CsBTdOqxFYh1/sjG7YpCVSoLTmvVLqJ+D8cWLscflk=";
            };
          })
        ]
        ++ [
          (buildFirefoxXpiAddon rec {
            pname = "karakeep";
            version = "1.2.5";
            file-number = "4477863";
            addonId = "karakeep@karakeep.app";
            src = pkgs.fetchurl {
              url = "https://addons.mozilla.org/firefox/downloads/file/${file-number}/${pname}-${version}.xpi";
              hash = "sha256-oPr/M1v975jiNyUnDG6AV5n6RBu+dUS+BJb2+T9kiBU=";
            };
          })
        ]
        ++ [
          (buildFirefoxXpiAddon rec {
            pname = "clickbait_remover_for_youtube";
            version = "0.7.1";
            file-number = "4043434";
            addonId = "cb-remover@search.mozilla.org";
            src = pkgs.fetchurl {
              url = "https://addons.mozilla.org/firefox/downloads/file/${file-number}/${pname}-${version}.xpi";
              hash = "sha256-o5gJZ1gydXItxHgBNUkco5jUJ1CydCDA3j5mnfl4xkk=";
            };
          })
        ]
        ++ [
          # Appears to be corrupted ?
          (buildFirefoxXpiAddon rec {
            pname = "hoarders-pipette";
            version = "1.3.0";
            addonId = "hoarder-pipette@dansnow.github.io";
            src = pkgs.fetchurl {
              url = "https://github.com/DanSnow/hoarder-pipette/releases/download/hoarder-pipette-v${version}/${pname}-${version}.xpi";
              hash = "sha256-gVFBt6NxRWVKfexvlyvA/uOlW0WgxUYUjTGzfrjLbjQ=";
            };
          })
        ];
      settings = {
        widget.use-xdg-desktop-portal.file-picker = 1; # use xdg-desktop-portal for file picker
        # Allow svgs to take on theme colors
        "svg.context-properties.content.enabled" = true;
        # Pressing TAB from address bar shouldn't cycle through buttons before
        # switching focus back to the webppage. Most of those buttons have
        # dedicated shortcuts, so I don't need this level of tabstop granularity.
        "browser.toolbars.keyboard_navigation" = false;

        # Seriously. Stop popping up on every damn page. If I want it translated,
        # I know where to find gtranslate/deepl/whatever!
        "browser.translations.automaticallyPopup" = false;
        # Enable userContent.css and userChrome.css for our theme modules
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Don't use the built-in password manager. A nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Firefox is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Remove the newtab page
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = cfg.firefox.homepageUrl;
        "browser.startup.homepage_override.mstone" = "ignore";
        # "browser.newtab.url" = cfg.firefox.searxngInstance;
        # Disable Activity Stream
        # https://wiki.mozilla.org/Firefox/Activity_Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
        # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
        # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Firefox won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # Since FF 113, you must press TAB twice to cycle through urlbar
        # suggestions. This disables that.
        "browser.urlbar.resultMenu.keyboardAccessible" = false;
        # https://bugzilla.mozilla.org/1642623
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true; # "Looks like you haven't started Firefox in a while."
        "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.pocket.enabled" = true;
        "extensions.unifiedExtensions.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "reader.parse-on-load.enabled" = false; # "reader view"
        # Security-oriented defaults
        "security.family_safety.mode" = 0;
        # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
        "security.pki.sha1_enforcement_level" = 1;
        # https://github.com/tlswg/tls13-spec/issues/1001
        "security.tls.enable_0rtt_data" = false;
        # Use Mozilla geolocation service instead of Google if given permission
        "geo.provider.network.url" =
          "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        # https://support.mozilla.org/en-US/kb/extension-recommendations
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false; # uses Google Analytics
        "browser.discovery.enabled" = false;
        # Reduce File IO / SSD abuse
        # Otherwise, Firefox bombards the HD with writes. Not so nice for SSDs.
        # This forces it to write every 30 minutes, rather than 15 seconds.
        "browser.sessionstore.interval" = "1800000";
        # Disable battery API
        # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        # http://kb.mozillazine.org/Browser.send_pings
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        # https://www.w3.org/TR/gamepad/
        # https://trac.torproject.org/projects/tor/ticket/13023
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        # https://wiki.mozilla.org/Platform/Features/Telemetry
        # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
        # https://wiki.mozilla.org/Telemetry
        # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
        # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
        # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
        # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
        # https://wiki.mozilla.org/Telemetry/Experiments
        # https://support.mozilla.org/en-US/questions/1197144
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        # https://mozilla.github.io/normandy/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        # Disable health reports (basically more telemetry)
        # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
        # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

        # Disable Form autofill
        # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;
      };
    };

  };
}
