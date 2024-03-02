{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    #./hardware-configuration.nix
    ../common/global
  ];

  # use the default configuration later
  users = {
    mutableUsers = false;
    users = {
      louis = {
        isNormalUser = true;
        description = "louis thevenet";
        extraGroups = ["networkmanager" "wheel"];
        shell = pkgs.zsh;
        home = "/home/louis";
        initialPassword = "tmp";
      };
    };
  };

  networking = {
    hostName = "rasberrypi";
  };

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
  ];

  services.openssh = {
    enable = true;
    permitRootLogin = true;
    #passwordAuthentication = false;
  };
}
