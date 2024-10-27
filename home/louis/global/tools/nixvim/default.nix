{
  pkgs,
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins
    ./completion.nix
    ./keymappings.nix
  ];
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = {
      cursorline = {
        enable = true;
        cursorline = {
          enable = true;
          timeout = 0;
          number = true;
        };
        cursorword = {
          enable = true;
          hl = {
            underline = true;
          };
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; [ ];
  };
}
