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
        cursorline = true;
        cursorcolumn = true;
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
          language-servers = ["markdown-oxide" "wakatime" "ltex-ls"];
        }
        {
          name = "typst";
          language-servers = ["tinymist" "wakatime"];
          auto-format = true; # see https://github.com/helix-editor/helix/issues/11237
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "wakatime"];
        }
        {
          name = "ocaml";
          language-servers = ["ocaml-lsp" "wakatime"];
          formatter = {
            command = lib.getExe pkgs.ocamlPackages.ocamlformat;
            args = ["-" "--impl" "--enable-outside-detected-project"];
          };
          auto-format = true;
        }
        {
          name = "toml";
          language-servers = ["taplo" "wakatime"];
        }
        {
          name = "java";
          language-servers = ["jdtls"];
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = ["nil" "wakatime"];
          auto-format = true;
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

        tinymist = {
          command = lib.getExe pkgs.tinymist;
          config = {
            exportPdf = "onType";
          };
        };

        ocaml-lsp = {
          command = lib.getExe pkgs.ocamlPackages.ocaml-lsp;
        };

        jdtls = let
          jdtls-bin =
            if (lib.versionOlder pkgs.jdt-language-server.version "1.31.0")
            then "jdt-language-server"
            else "jdtls";
        in {
          command = "${pkgs.jdt-language-server}/bin/${jdtls-bin}";
          args = [
            "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar"
          ];
        };

        rust-analyzer = {
          command = lib.getExe pkgs.rust-analyzer;
          config = {
            check = {
              checkOnSave = true;
              command = "clippy";
              extraArgs = ["--" "-W" "clippy::complexity" "-W" "clippy::perf" "-W" "clippy::style" "-W" "clippy::pedantic" "-W" "clippy::nursery"];
            };
          };
        };

        ltex-ls = {
          command = lib.getExe' pkgs.ltex-ls "ltex-ls";
          config.ltex = {
            disabledRules = {
              en = [
                "ARROWS"
              ];
              fr = [
                "FLECHES"
              ];
            };
            additionnalRules = {
              enablePickyRules = true;
            };
            language = "auto";
          };
        };

        wakatime.command = lib.getExe inputs.wakatime-lsp.packages.${pkgs.system}.default;
      };
    };
  };
}
