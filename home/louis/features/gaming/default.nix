{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    steam
    prismlauncher
    # lutris
    # wine
    # heroic
    # goverlay
    # mangohud
  ];
}
