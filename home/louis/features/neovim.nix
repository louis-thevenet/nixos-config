{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
    ];

    extraConfig = ''
      set number relativenumber
    '';

  };
}
