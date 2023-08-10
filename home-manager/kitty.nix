{ packages, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.fira-code;
      name = "firacode";
      size = 12;
    };
  };
}
