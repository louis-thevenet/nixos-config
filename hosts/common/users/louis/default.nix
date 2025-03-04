{
  pkgs,
  config,
  ...
}:
let
  passwordFile = config.sops.secrets.sys-passphrase.path;
in
{
  users = {
    mutableUsers = false;
    users = {
      louis = {
        isNormalUser = true;
        description = "louis thevenet";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.fish;
        home = "/home/louis";
        hashedPasswordFile = passwordFile;
      };
    };
  };

  security.pam.services.swaylock = { };

  sops.secrets.wakatime_cfg = {
    sopsFile = ../../secrets.yaml;
    path = "/home/louis/.wakatime.cfg";
    owner = "louis";
  };
}
