{ config, ... }:
{
  sops.secrets.ssh-host-key = {
    sopsFile = ../secrets.yaml;
    owner = "louis";
  };
  services.openssh = {
    enable = true;
    allowSFTP = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
    hostKeys = [
      {
        inherit (config.sops.secrets.ssh-host-key) path;
        type = "ed25519";
      }
    ];
    extraConfig = ''
      AllowTcpForwarding yes
      AllowAgentForwarding yes
      AllowStreamLocalForwarding no
      AuthenticationMethods publickey
    '';
  };
}
