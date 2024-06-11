{config, ...}: let
  inherit (config) colorscheme;
in {
  home.sessionVariables.COLORTERM = "truecolor";
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        color-modes = true;
        line-number = "relative";
        indent-guides.render = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
      };
    };
  };
}
