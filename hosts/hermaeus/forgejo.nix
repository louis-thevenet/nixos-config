{ config, ... }:
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
  };
}
