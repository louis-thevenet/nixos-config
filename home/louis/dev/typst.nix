{pkgs, ...}: {
  home.packages = with pkgs; [
    typst
    typst-lsp
    typst-fmt
  ];
}
