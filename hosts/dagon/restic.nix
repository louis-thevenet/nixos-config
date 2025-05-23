{ config, ... }:
{
  users.users = {
    backups = {
      isSystemUser = true;
      group = "backups";
      extraGroups = [
        "nextcloud"
        "karakeep"
      ];
    };
  };
  users.groups.backups = { };
  sops.secrets.dagon-backups-password = {
    sopsFile = ../common/secrets.yaml;
    owner = "backups";
  };
  # https://francis.begyn.be/blog/nixos-restic-backups
  services.restic.backups = {
    ssd-backup = {
      user = "backups";
      repository = "/backups";
      initialize = true;
      passwordFile = config.sops.secrets.dagon-backups-password.path;
      paths = [
        "/var/lib/karakeep"
        "/var/lib/nextcloud"
      ];
      extraBackupArgs = [
        "--exclude=/var/lib/nextcloud/.rnd" # openssl stuff
        "--exclude=/var/lib/karakeep/settings.env" # produced by NixOS anyway
      ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
