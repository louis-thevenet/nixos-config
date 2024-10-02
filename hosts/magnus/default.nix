{
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

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.udisks2.enable = true;
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most wayland compositors
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "560.35.03";
      sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      sha256_aarch64 = "sha256-s8ZAVKvRNXpjxRYqM3E5oss5FdqW+tv1qQC2pDjfG+s=";
      openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
      settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
      persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
    };
  };
}
