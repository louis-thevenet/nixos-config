{ config, ... }:
{
  imports = [
    ./lsp.nix
  ];

  programs.nixvim = {
    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "+";
            change.text = "~";
          };
        };
      };
      nvim-autopairs.enable = true;

      nvim-colorizer = {
        enable = true;
        userDefaultOptions.names = false;
      };
    };
  };
}
