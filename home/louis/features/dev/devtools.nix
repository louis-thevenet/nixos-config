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
      nix-tree
      claude-code
      tokei
    ]
  );
  programs.gh.enable = true;
  programs.lazygit = {
    enable = true;
    settings.git = {
      overrideGpg = true;
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      lsp = true;
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama";
          options = {
            baseURL = "http://192.168.1.183:11434/v1";
          };
          models = {
            "laguna-xs-2.1:q4_K_M".name = "laguna-xs-2.1:q4_K_M";
            "laguna-xs-2.1:q8_0".name = "laguna-xs-2.1:q8_0";
            "ornith:35b".name = "ornith:35b";
            "gemma4:e4b".name = "gemma4:e4b";
            "ornith:9b".name = "ornith:9b";
            "gemma4:31b".name = "gemma4:31b";
          };
        };

        lmstudio = {
          npm = "@ai-sdk/openai-compatible";
          name = "LM Studio (local)";
          options = {
            baseURL = "http://127.0.0.1:1234/v1";
          };
        };
      };
    };
  };
  programs.tmux = mkIf cfg.devTools.enable {
    enable = true;
    clock24 = true;
    prefix = "C-a";
    baseIndex = 1;
    mouse = true;
    disableConfirmationPrompt = true;
    escapeTime = 0;
    historyLimit = 5000;
    # plugins =
    #   # let
    #   #   inherit (pkgs.tmuxPlugins) resurrect continuum;
    #   # in
    #   # [
    #   #   {
    #   #     plugin = resurrect;
    #   #     extraConfig = "set -g @resurrect-processes '\"~hx->hx *\" lazygit vault-tasks spotify-player'";
    #   #   }
    #   #   {
    #   #     plugin = continuum;
    #   #     extraConfig = ''
    #   #       set -g @continuum-restore 'on'
    #   #       set -g @continuum-save-interval '5' # minutes
    #   #     '';
    #   #   }
    #   # ];
  };
}
