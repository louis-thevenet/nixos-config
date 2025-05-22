{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./sops.nix
    ../common/global
    ../common/users/louis
    ../common/optional/services.nix
    ../common/optional/airpods-battery-fetcher.nix
    ../common/optional/stylix.nix
    ../common/optional/niri.nix
    ../common/optional/ollama.nix
    ../common/optional/kanata.nix
    ../common/optional/xdg.nix
    ../common/optional/virt.nix
  ];
  networking.hostName = "magnus";
  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    # mount iphone storage with `ifuse ./mnt/iphone`
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

  hardware = {
    bluetooth.enable = true; # enables support for Bluetooth
    bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    graphics.enable = true;
    nvidia = {
      # Modesetting is needed for most wayland compositors
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      #   package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #     version = "535.154.05";
      #     sha256_64bit = "sha256-fpUGXKprgt6SYRDxSCemGXLrEsIA6GOinp+0eGbqqJg=";
      #     sha256_aarch64 = "sha256-G0/GiObf/BZMkzzET8HQjdIcvCSqB1uhsinro2HLK9k=";
      #     openSha256 = "sha256-wvRdHguGLxS0mR06P5Qi++pDJBCF8pJ8hr4T8O6TJIo=";
      #     settingsSha256 = "sha256-9wqoDEWY4I7weWW05F4igj1Gj9wjHsREFMztfEmqm10=";
      #     persistencedSha256 = "sha256-d0Q3Lk80JqkS1B54Mahu2yY/WocOqFFbZVBh+ToGhaE=";
      #   };
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  services = {
    udisks2.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };
  programs.steam.enable = true;
}
