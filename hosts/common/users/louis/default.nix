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

      mkdir -p ''${dirname ${passwordFile}} && touch ${passwordFile}
      echo "$y$j9T$fRcgMeFa9VRjBE0yitrh70$DR1AoWRerynpYpLpW5Ncmi8KYFFPlJfqRgUzDbVgnT1" > ${passwordFile}

      # what if the update users script runs before this one? Let's change the password in case
      yes tmp | passwd louis
    fi
  '';
  security.pam.services.swaylock = {};
}
