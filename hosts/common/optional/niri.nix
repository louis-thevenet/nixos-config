{ pkgs, ... }:
{

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };
  programs.xwayland.enable = true;
}
