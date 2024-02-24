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

  system.activationScripts.createDefaultPasswordFile = ''
    if [ ! -f ${passwordFile} ]; then
      echo -e "\e[31m${passwordFile} doesn't exist, creating it. Password is \"tmppwd\" \e[0m"

      mkdir -p $(dirname ${passwordFile})
      echo "$y$j9T$frTeOx1XSSp87P5svRYjb.$7Hx9d2pJs8UYYElzoeukYiB6jU.UPK5ZXnj0VgkqHg5" > ${passwordFile}

      # what if the update users script runs before this one? Let's change the password in case
      yes tmppwd | passwd louis
    fi
  '';
  security.pam.services.swaylock = {};
}
