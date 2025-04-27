{
  lib,
  inputs,
  pkgs,
  ...
}:
# let

#   copilot = pkgs.writeShellScriptBin "copilot" "${lib.getExe pkgs.nodejs} ${pkgs.vimPlugins.copilot-vim}/dist/language-server.js";
#   helix-copilot = pkgs.symlinkJoin {
#     name = "helix";
#     paths = [
#       inputs.helix.packages.${pkgs.system}.helix
#     ];
#     buildInputs = [ pkgs.makeWrapper ];
#     runtimeInputs = [
#       copilot
#     ];
#     postBuild = ''
#       wrapProgram $out/bin/hx --add-flags "-a"
#     '';
#   };
# in
{
  # home.packages = [ copilot ];
  programs.helix = {
    enable = true;
    # package = helix-copilot;
    defaultEditor = true;

    settings = {
      editor = {
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "hint";
        };
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
          center = [ ];
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

        normal = {
          "C-y" =
            let
              yazi = lib.getExe pkgs.yazi;
            in
            [
              ":sh rm -f /tmp/unique-file"
              ":insert-output ${yazi} %{buffer_name} --chooser-file=/tmp/unique-file"
              '':insert-output echo "\x1b[?1049h" > /dev/tty''
              ":open %sh{cat /tmp/unique-file}"
              ":redraw"
              ":set mouse false"
              ":set mouse true"
            ];
          # "C-e" = "copilot_toggle_auto_render";
          "h" = "no_op";
          "j" = "no_op";
          "k" = "no_op";
          "l" = "no_op";

          "!" = "no_op";

          "ret" = "goto_word";
          backspace = {
            "t" = "@i- [ ] today ";
            "n" = "@i- [ ] ";

            # Aliases for <mi+chr>
            "\"" = "@mi\"";
            "{" = "@mi\{";
            "[" = "@mi\[";
            "(" = "@mi\(";

            # Jump between Markdown headers
            "A-j" = "@/^#+\s+.*$<ret>";
            "A-k" = "@?^#+\s+.*$<ret>";

            "y" = ":yank-diagnostic";
          };

          x = [
            "extend_line_below"
          ];
          X = [
            "extend_line_above"
          ];
        };
        select = {
          x = [
            "extend_line_below"
          ];
          X = [
            "extend_line_above"
          ];
        };
      };
    };

    languages = {
      language = [
        {
          name = "bash";
          language-servers = [
            "bash-language-server"
            "gpt"
            "typos"
          ];
          formatter = {
            command = "${pkgs.shfmt}/bin/shfmt";
            args = [
              "-i"
              "2"
              "-"
            ];
          };
        }
        {
          name = "markdown";
          language-servers = [
            "markdown-oxide"
            "wakatime"
            "ltex-ls"
          ];
          formatter = {
            command = lib.getExe pkgs.nodePackages.prettier;
            args = [
              "--stdin-filepath"
              "file.md"
            ];
          };
          auto-format = true;
        }
        {
          name = "typst";
          language-servers = [
            "tinymist"
            "wakatime"
          ];
          formatter = {
            command = lib.getExe pkgs.typstyle;
          };
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [
            "python-lsp"
            "wakatime"
            "typos"
          ];
          formatter = {
            command = lib.getExe pkgs.python312Packages.yapf;
          };
          auto-format = true;
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "wakatime"
            "typos"
          ];
        }

        {
          name = "ocaml";
          file-types = [
            "ml"
            "mli"
          ];
          language-servers = [
            "ocaml-lsp"
            "wakatime"
          ];
          formatter = {
            command = lib.getExe pkgs.ocamlPackages.ocamlformat;
            args = [
              "-"
              "--impl"
              "--enable-outside-detected-project"
            ];
          };
          auto-format = true;
        }
        {
          name = "toml";
          language-servers = [
            "taplo"
            "wakatime"
            "typos"
          ];
        }
        {
          name = "javascript";
          language-servers = [

            "typescript-language-server"

          ];
          auto-format = true;
        }
        {
          name = "java";
          language-servers = [ "jdtls" ];
          auto-format = true;
        }
        {
          name = "nix";
          language-servers = [
            "nixd"
            "wakatime"
            "typos"
          ];
          formatter.command = lib.getExe pkgs.pkgs.nixfmt-rfc-style;
          auto-format = true;
        }
        {
          name = "fish";
          language-servers = [
            "fish"
            "wakatime"
          ];
        }
      ];
      language-server = {
        fish = {
          command = lib.getExe pkgs.fish-lsp;
          args = [ "start" ];
          environment.fish_lsp_show_client_popups = "false";
        };

        typescript-language-server = {
          command = lib.getExe pkgs.nodePackages_latest.typescript-language-server;
        };
        gpt = {
          command = lib.getExe pkgs.helix-gpt;
          args = [
            "--handler"
            "ollama"
            # "--logFile"
            # "helix-gpt.log"
          ];
        };
        bash-language-server = {
          command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
          args = [ "start" ];
        };

        markdown-oxide.command = lib.getExe pkgs.markdown-oxide;

        toml.command = lib.getExe pkgs.taplo;

        nil = {
          command = lib.getExe pkgs.nil;
          config.nil.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style} --width=110" ];
        };

        nixd = {
          command = lib.getExe pkgs.nixd;
          config = {
            nixpkgs.expr = "import <nixpkgs> { }";
            options = {
              nixos.expr = ''(builtins.getFlake "/home/louis/src/nixos-config").nixosConfigurations.magnus.options'';
              # Only for standalone
              # home-manager.expr = ''(builtins.getFlake "/home/louis/src/nixos-config").homeConfigurations."louis@magnus".options'';
            };
          };
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
        python-lsp = {
          command = lib.getExe pkgs.python312Packages.python-lsp-server;
        };

        jdtls =
          let
            jdtls-bin =
              if (lib.versionOlder pkgs.jdt-language-server.version "1.31.0") then
                "jdt-language-server"
              else
                "jdtls";
          in
          {
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
              extraArgs = [
                "--"
                # "-W"
                # "clippy::complexity"
                "-W"
                "clippy::perf"
                # "-W"
                # "clippy::style"
                "-W"
                "clippy::pedantic"
                "-A"
                "clippy::pedantic::missing_errors_doc"
                # "-W"
                # "clippy::nursery"
              ];
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
        typos = {
          command = lib.getExe pkgs.typos-lsp;
          config.config = pkgs.writeText "typos.toml" ''
            [default.extend-identifiers]
            ratatui = "ratatui"
          '';
        };
      };
    };

  };
}
