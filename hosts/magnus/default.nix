{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/airpods-battery-fetcher.nix
    ../common/optional/stylix.nix
    ../common/optional/hyprland.nix
  ];
  networking.hostName = "magnus";
  services = {
    xserver = {
      enable = true;
      xkb.layout = "fr";
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.udisks2.enable = true;
  hardware.graphics.enable = true;

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "535.154.05";
      sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
    };
  };
}
