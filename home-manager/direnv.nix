{ packages, pkgs, ... }: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
