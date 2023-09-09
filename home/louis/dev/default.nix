{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix
    nil
    alejandra
    python311Packages.nix-prefetch-github

    # C
    cmake
    gnat13 # replaces gcc to add Ada compiler
    clang-tools
    valgrind
    gdb
    hyperfine

    # python
    (python310.withPackages (ps: with ps; [bleak pyusb]))
  ];
}
