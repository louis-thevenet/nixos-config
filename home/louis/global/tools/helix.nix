{
  lib,
  inputs,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      editor = {
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 500;
          };
        };
        bufferline = "multiple";
        color-modes = true;
        line-number = "relative";
        indent-guides.render = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        soft-wrap.enable = true;
        text-width = 110;

        statusline = {
          left = [
            "mode"
            "spinner"
            "version-control"
            "file-name"
            "read-only-indicator"
            "file-modification-indicator"
          ];
          center = [];
          right = [
            "diagnostics"
            "selections"
            "register"
            "position-percentage"
            "position"
            "file-encoding"
          ];
        };
      };

      keys = {
        # insert = {
        #   "C-w" = "copilot_apply_completion";
        #   "C-e" = "copilot_show_completion";
        # };

        # normal = {
        #   "C-e" = "copilot_toggle_auto_render";
        # };
      };
    };

    languages = {
      language = [
        {
          name = "bash";
          language-servers = ["bash-language-server"];
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = ["-i" "2" "-"];
          };
        }
        {
          name = "markdown";
          language-servers = ["markdown-oxide" "wakatime" "vale"];
        }
        {
          name = "typst";
          language-servers = ["typst-lsp" "wakatime" "vale"];
          auto-format = false; # see https://github.com/helix-editor/helix/issues/11237
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "wakatime"];
        }
        {
          name = "toml";
          language-servers = ["taplo" "wakatime"];
        }
        {
          name = "nix";
          language-servers = ["nil" "wakatime"];
          auto-format = true; # see https://github.com/helix-editor/helix/issues/11237
        }
      ];
      language-server = {
        bash-language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = ["start"];
        };

        markdown-oxide.command = lib.getExe pkgs.markdown-oxide;
        toml.command = lib.getExe pkgs.taplo;
        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
        };

        vale = {
          command = lib.getExe pkgs.vale-ls;
        };

        wakatime.command = lib.getExe inputs.wakatime-lsp.packages.${pkgs.system}.default;
      };
    };
  };
}
