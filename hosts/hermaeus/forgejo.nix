{ config, pkgs, ... }:
let
  domain = "git.ltvnt.com";
  httpPort = 3000;
  sshPort = 2222;
in
{
  sops.secrets."forgejo-actions-runner-token" = {
    sopsFile = ./secrets.yaml;
  };

  virtualisation.docker.enable = true;

  environment.etc."git-pages/config.toml".text = ''
    [storage]
    type = "fs"

    [storage.fs]
    root = "/var/lib/git-pages"

    [server]
    pages = "tcp/127.0.0.1:3001"
    caddy = "tcp/127.0.0.1:3002"
    metrics = "tcp/127.0.0.1:3003"

    [limits]
    allowed-repository-url-prefixes = ["https://git.ltvnt.com/"]
  '';

  systemd.services.git-pages = {
    description = "git-pages static site server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.git-pages}/bin/git-pages -config /etc/git-pages/config.toml";
      StateDirectory = "git-pages";
      DynamicUser = true;
      PrivateTmp = true;
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  networking.firewall.allowedTCPPorts = [ sshPort ];

  services = {
    forgejo = {
      enable = true;
      lfs.enable = true;
      settings = {
        server = {
          DOMAIN = domain;
          ROOT_URL = "https://${domain}/";
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = httpPort;
          SSH_PORT = sshPort;
          SSH_LISTEN_PORT = sshPort;
        };
        service.DISABLE_REGISTRATION = false;
        actions = {
          ENABLED = true;
          # resolve unqualified `uses: owner/repo@ref` against github.com instead of
          # Forgejo's curated data.forgejo.org mirror, which only carries a subset of actions
          DEFAULT_ACTIONS_URL = "github";
        };
      };
    };

    gitea-actions-runner.instances.hermaeus = {
      enable = true;
      name = "hermaeus";
      url = "http://127.0.0.1:${toString httpPort}";
      tokenFile = config.sops.secrets."forgejo-actions-runner-token".path;
      labels = [
        # mirrors GitHub's hosted ubuntu-latest runner (sudo, apt, build tools, node, etc.
        # already present) so off-the-shelf actions work unmodified
        "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-latest"
      ];
      settings = {
        # job containers share the host's network namespace, so http://127.0.0.1:<httpPort>
        # (the runner's own instance URL) is reachable from inside the container
        container.network = "host";
      };
    };

    nginx.virtualHosts.${domain} = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString httpPort}";
        proxyWebsockets = true;
        extraConfig = ''
          client_max_body_size 512M;
        '';
      };
    };

    nginx.virtualHosts."absent-light.ltvnt.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          add_header Cross-Origin-Opener-Policy "same-origin" always;
          add_header Cross-Origin-Embedder-Policy "require-corp" always;
        '';
      };
    };
  };
}
