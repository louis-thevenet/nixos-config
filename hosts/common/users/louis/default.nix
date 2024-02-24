{
  pkgs,
  config,
  ...
}: let
  passwordFile = config.sops.secrets.sys-passphrase.path;
in {
  users = {
    mutableUsers = false;
    users = {
      louis = {
        isNormalUser = true;
        description = "louis thevenet";
        extraGroups = ["networkmanager" "wheel"];
        shell = pkgs.zsh;
        home = "/home/louis";
        hashedPasswordFile = passwordFile;
      };
    };
  };

  security.pam.services.swaylock = {};
}
