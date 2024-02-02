{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    lutris
    steam
    wine
    heroic
  ];
}
