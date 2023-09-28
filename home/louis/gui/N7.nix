{pkgs, ...}: {
  home.packages = with pkgs; [
    coq
  ];
}
