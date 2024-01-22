{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.rust-rover
    jetbrains.idea-ultimate
    #jetbrains.clion
    #jetbrains.pycharm-professional
  ];
}
