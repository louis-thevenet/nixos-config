{pkgs, ...}: {
  home.packages = with pkgs; [
    nil
    alejandra
    python311Packages.nix-prefetch-github
  ];
}
