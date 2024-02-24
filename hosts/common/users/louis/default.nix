{
  pkgs,
  config,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      louis = {
        isNormalUser = true;
        description = "louis thevenet";
        extraGroups = ["networkmanager" "wheel"];
        shell = pkgs.zsh;
        home = "/home/louis";
        hashedPasswordFile = config.sops.secrets.sys-passphrase.path;
      };
    };
  };
  security.pam.services.swaylock = {};
}
