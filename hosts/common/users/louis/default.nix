{
  pkgs,
  config,
  ...
}: {
  users.users.louis = {
    isNormalUser = true;
    description = "louis thevenet";
    extraGroups = ["networkmanager" "wheel"];
  };
  users.users.louis.shell = pkgs.zsh;
  users.users.louis.packages = with pkgs; [];
}
