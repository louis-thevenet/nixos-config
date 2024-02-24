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
      echo -e "\e[31m${passwordFile} doesn't exist, creating it. Password is \"tmp\" \e[0m"

      mkdir -p $(dirname ${passwordFile})
      echo "$6$KJkipd5jIyIQSA3L$WwEKtx69GoKsMucjvLEfmZCm87y62sDDOl1JEslXmHLlNeql8zKiGmGVYBF3Q4cj/qJSR9OA2tdyN4hK4jjVc." > ${passwordFile}

      # what if the update users script runs before this one? Let's change the password in case
      yes tmp | passwd louis
    fi
  '';
  security.pam.services.swaylock = {};
}
