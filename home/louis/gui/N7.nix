{pkgs, ...}: {
  home.packages = with pkgs; [
    coq
    coqPackages.coqide
  ];
}
