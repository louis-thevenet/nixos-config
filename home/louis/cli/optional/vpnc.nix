{pkgs, ...}: {
  home.packages = with pkgs; [
    vpnc
  ];
}
