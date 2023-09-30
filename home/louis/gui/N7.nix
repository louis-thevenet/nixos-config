{pkgs, ...}: {
  home.packages = with pkgs; [
    coq
    coqPackages.coqide
    x2goclient
  ];
}
