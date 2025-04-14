{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
in
{
  home.packages = mkIf cfg.devTools.enable (
    with pkgs;
    [
      tokei
    ]
  );

  programs.lazygit.enable = true;

  programs.tmux = mkIf cfg.devTools.enable {
    enable = true;
    clock24 = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 5000;
    plugins =
      let
        inherit (pkgs.tmuxPlugins) resurrect continuum;
      in
      [
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-processes '\"~hx->hx *\" lazygit vault-tasks spotify-player'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5' # minutes
          '';
        }
      ];
  };
}
