{
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    xwayland.enable = true;
    enable = true;
  };

  environment.systemPackages = [
    inputs.hyprland-qtutils.packages.${pkgs.system}.default
  ];
}
