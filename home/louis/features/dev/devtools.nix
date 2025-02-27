{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.home-config.dev;
  src =
    let
      fzf = lib.getExe' pkgs.fzf "fzf-tmux";
      find = lib.getExe pkgs.findutils;
    in
    pkgs.writeShellScriptBin "src" ''
      DIR=`${find} /home/louis/src/* -maxdepth 0 -type d,l -print 2> /dev/null | ${fzf}`
      cd "$DIR"
      "$SHELL"
    '';
  dev =
    let
      tmux = lib.getExe pkgs.tmux;
      basename = lib.getExe' pkgs.coreutils "basename";
      pwd = lib.getExe' pkgs.coreutils "pwd";
      lazygit = lib.getExe pkgs.lazygit;
      helix = lib.getExe pkgs.helix;
    in
    pkgs.writeShellScriptBin "dev" ''
      ${tmux} new -Ads $(${basename} "$(${pwd})") '${helix} .'
      ${tmux} new-window
      ${tmux} new-window '${lazygit}'
      ${tmux} select-window -t 1
      ${tmux} attach-session -t $(${basename} "$(${pwd})")
    '';
in
{
  home.packages = mkIf cfg.devTools.enable (
    with pkgs;
    [
      tokei
      src
      dev
    ]
    ++ [
      inputs.patchy.packages.${pkgs.system}.default
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
