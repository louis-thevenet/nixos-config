{ pkgs, ... }:
{

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  programs.xwayland.enable = true;
}
