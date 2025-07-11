{ pkgs, ... }:
{
  services.nix-serve = {
    enable = true;
    bindAddress = "0.0.0.0";
  };
  systemd.services.nix-serve-key-gen = {
    description = "Generate signing key for nix-serve";
    wantedBy = [ "multi-user.target" ];
    before = [ "nix-serve.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f /var/lib/nix-serve/cache-priv-key.pem ]; then
        mkdir -p /var/lib/nix-serve
        ${pkgs.nix}/bin/nix-store --generate-binary-cache-key \
          local-cache \
          /var/lib/nix-serve/cache-priv-key.pem \
          /var/lib/nix-serve/cache-pub-key.pem
        chown -R nix-serve:nix-serve /var/lib/nix-serve
      fi
    '';
  };

  systemd.services.nix-serve = {
    environment = {
      NIX_SECRET_KEY_FILE = "/var/lib/nix-serve/cache-priv-key.pem";
    };
    wants = [ "nix-serve-key-gen.service" ];
    after = [ "nix-serve-key-gen.service" ];
  };

}
