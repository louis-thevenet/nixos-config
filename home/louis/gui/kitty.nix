{
  packages,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    theme = "Github";
    settings = {
      #background_opacity = "0.8";
    };
    font = {
      package = pkgs.fira-code;
      name = "firacode";
      size = 12;
    };
  };
}
