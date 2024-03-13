{pkgs, ...}: {
  home.packages = with pkgs; [
    bitwarden
    onlyoffice-bin
    super-productivity
  ];
}
