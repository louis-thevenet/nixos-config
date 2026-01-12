{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.home-config.dev;
in
{
  sops.secrets.copilot-api-key = {
    sopsFile = ../../../../hosts/common/secrets.yaml;
  };

  programs.helix = {
    enable = true;
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
          "C-left" = ":buffer-previous";
          "C-right" = ":buffer-next";
          "C-down" = "goto_next_diag";
          "C-up" = "goto_prev_diag";

          "h" = "no_op";
          "j" = "no_op";
          "k" = "no_op";
          "l" = "no_op";
          "!" = "no_op";
          "ret" = "goto_word";
          backspace = {
            # Vault-tasks stuff t = "@i- [ ] today ";
            n = "@i- [ ] ";
            # Write current time
            d = ":insert-output ${lib.getExe' pkgs.coreutils "date"} +'## %%H:%%M:%%S'";
            # Write current date and time
            D = [
              '':insert-output echo "# $(${lib.getExe' pkgs.coreutils "date"} +'%%A, %%d %%B %%Y' | ${lib.getExe pkgs.gnused} -e 's/./\u&/')"''
              "open_below"
              ":insert-output ${lib.getExe' pkgs.coreutils "date"} +'## %%H:%%M:%%S'"
            ];
            r = [
              ":insert-output vault-tasks --vault-path ./ fix"
              ":reload"
            ];
            y = ":yank-diagnostic";
          };
          x = [ "extend_line_below" ];
          X = [ "extend_line_above" ];
        };
        select = {
          x = [ "extend_line_below" ];
          X = [ "extend_line_above" ];
        };
      };
    };
    languages =

      if cfg.helixAdvancedConfig.enable then
        {
          language = [
            {
              name = "bash";
              language-servers = [
                "bash-language-server"
                "gpt"
                "typos"
                "wakatime"
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
              name = "c";
              language-servers = [
                "clangd"
                "gpt"
                "typos"
                "wakatime"
              ];
              formatter = {
                command = lib.getExe' pkgs.clang-tools "clang-format";
                args = [ "-" ];
              };
            }
            {
              name = "fish";
              language-servers = [
                "fish"
                "gpt"
                "typos"
                "wakatime"
              ];
            }
            {
              name = "java";
              language-servers = [
                "jdtls"
                "gpt"
                "typos"
                "wakatime"
              ];
              auto-format = true;
            }
            {
              name = "javascript";
              language-servers = [
                "typescript-language-server"
                "gpt"
                "typos"
                "wakatime"
              ];
              auto-format = true;
            }
            {
              name = "markdown";
              language-servers = [
                "ltex-ls"
                "markdown-oxide"
                "gpt"
                "typos"
                "wakatime"
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
              name = "nix";
              language-servers = [
                "nixd"
                "gpt"
                "typos"
                "wakatime"
              ];
              formatter.command = lib.getExe pkgs.pkgs.nixfmt-rfc-style;
              auto-format = true;
            }
            {
              name = "ocaml";
              file-types = [
                "ml"
                "mli"
              ];
              language-servers = [
                "ocaml-lsp"
                "gpt"
                "typos"
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
              name = "python";
              auto-format = true;
              formatter = {
                command = "ruff";
                args = [
                  "format"
                  "--line-length=80"
                  "-"
                ];
              };
              language-servers = [
                "ty"
                "basedpyright"
                "ruff"
                "gpt"
              ];
            }
            {
              name = "rust";
              language-servers = [
                "rust-analyzer"
                "gpt"
                "typos"
                "wakatime"
              ];
            }
            {
              name = "cuda";
              language-servers = [
                "gpt"
                "typos"
                "wakatime"
              ];
            }
            {
              name = "toml";
              language-servers = [
                "taplo"
                "gpt"
                "typos"
                "wakatime"
              ];
            }
            {
              name = "typst";
              language-servers = [
                "tinymist"
                "gpt"
                "typos"
                "wakatime"
              ];
              formatter.command = lib.getExe pkgs.typstyle;
              auto-format = true;
            }
            {
              name = "cuda";
              scope = "source.cuda";
              language-servers = [
                "clangd"
              ];
              file-types = [
                "cu"
              ];
            }
          ];

          language-server = {
            basedpyright = {
              command = lib.getExe' pkgs.basedpyright "basedpyright-langserver";
              config.python.analysis.typeCheckingMode = "basic";
            };
            ruff.command = lib.getExe pkgs.ruff;
            ty.command = lib.getExe pkgs.ty;
            bash-language-server = {
              command = "${pkgs.nodePackages.bash-language-server}/bin/bash-language-server";
              args = [ "start" ];
            };
            fish = {
              command = lib.getExe pkgs.fish-lsp;
              args = [ "start" ];
              environment.fish_lsp_show_client_popups = "false";
            };
            gpt =
              let
                gpt-wrapped = pkgs.writeShellScriptBin "helix-gpt" ''
                  export COPILOT_API_KEY=$(cat ${config.sops.secrets.copilot-api-key.path})
                  ${lib.getExe pkgs.helix-gpt} "$@"
                '';
              in
              {
                command = lib.getExe gpt-wrapped;
                args = [
                  "--handler"
                  "copilot"
                ];
              };
            jdtls = {
              command = "${pkgs.jdt-language-server}/bin/${
                if lib.versionOlder pkgs.jdt-language-server.version "1.31.0" then
                  "jdt-language-server"
                else
                  "jdtls"
              }";
              args = [ "--jvm-arg=-javaagent:${pkgs.lombok}/share/java/lombok.jar" ];
            };
            ltex-ls = {
              command = lib.getExe' pkgs.ltex-ls "ltex-ls";
              config.ltex = {
                disabledRules.en = [ "ARROWS" ];
                disabledRules.fr = [ "FLECHES" ];
                additionnalRules.enablePickyRules = true;
                language = "auto";
              };
            };
            markdown-oxide.command = lib.getExe pkgs.markdown-oxide;
            nixd = {
              command = lib.getExe pkgs.nixd;
              config = {
                nixpkgs.expr = "import <nixpkgs> { }";
                options.nixos.expr = ''(builtins.getFlake "/home/louis/src/nixos-config").nixosConfigurations.magnus.options'';
              };
            };
            clangd = {
              command = lib.getExe' pkgs.clang-tools "clangd";
              config = {
                clangd = {
                  fallbackFlags = [
                    "-std=c++20"
                  ];
                };
              };
            };
            ocaml-lsp.command = lib.getExe pkgs.ocamlPackages.ocaml-lsp;
            python-lsp.command = lib.getExe pkgs.python312Packages.python-lsp-server;
            rust-analyzer = {
              command = lib.getExe pkgs.rust-analyzer;
              config.check = {
                checkOnSave = true;
                command = "clippy";
                extraArgs = [
                  "--"
                  "-W"
                  "clippy::perf"
                  "-W"
                  "clippy::pedantic"
                  "-A"
                  "clippy::pedantic::missing_errors_doc"
                  # Bevy uses lots of these
                  "-A"
                  "clippy::needless_pass_by_value"
                ];
              };
            };
            taplo.command = lib.getExe pkgs.taplo;
            tinymist = {
              command = lib.getExe pkgs.tinymist;
              config.exportPdf = "onType";
            };
            typescript-language-server.command = lib.getExe pkgs.nodePackages_latest.typescript-language-server;
            typos = {
              command = lib.getExe pkgs.typos-lsp;
              config.config = pkgs.writeText "typos.toml" ''
                [default.extend-identifiers]
                ratatui = "ratatui"
              '';
            };
            wakatime.command = lib.getExe inputs.wakatime-lsp.packages.${pkgs.system}.default;
          };
        }
      else
        { };
  };
}
