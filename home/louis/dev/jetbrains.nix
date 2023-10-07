{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.clion
    jetbrains.pycharm-professional
  ];
}
