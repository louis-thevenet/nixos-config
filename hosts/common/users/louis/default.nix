{
  pkgs,
  config,
  ...
}: {
  users.users.louis = {
    isNormalUser = true;
    description = "louis thevenet";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };
  security.pam.services.swaylock = {};
}
