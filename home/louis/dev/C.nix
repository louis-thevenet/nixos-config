{pkgs, ...}: {
  home.packages = with pkgs; [
    cmake
    gnat13 # replaces gcc to add Ada compiler
    clang-tools
    valgrind
    gdb
    hyperfine
  ];
}
