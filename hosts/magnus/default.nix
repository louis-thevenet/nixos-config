{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/louis
    ../optional/gnome.nix
  ];

  networking.hostName = "magnus";
  services.xserver.videoDrivers = ["nvidia"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"]; # allows building iso for arm devices

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
