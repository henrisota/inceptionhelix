{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe getExe';
in {
  language-server = {
    bash-language-server = {
      command = getExe pkgs.bash-language-server;
      args = ["start"];
      environment.SHELLCHECK_ARGUMENTS = "-e SC2164";
    };
    clangd = {
      command = getExe' pkgs.clang-tools "clangd";
      clangd.fallbackFlags = ["-std=c++2b"];
    };
    eslint = {
      command = getExe' pkgs.nodePackages_latest.vscode-langservers-extracted "eslint-languageserver";
      args = ["--stdio"];
      config = {
        format = false;
        packageManages = "npm";
        nodePath = "";
        workingDirectory.mode = "auto";
        onIgnoredFiles = "off";
        run = "onType";
        validate = "on";
        useESLintClass = false;
        experimental = {};
        codeAction = {
          disableRuleComment = {
            enable = true;
            location = "separateLine";
          };
          showDocumentation.enable = true;
        };
      };
    };
    gopls = {
      command = getExe pkgs.gopls;
      gofumpt = true;
      staticcheck = true;
      verboseOutput = true;
      completeUnimported = true;

      config = {
        analyses = {
          nilness = true;
          unusedparams = true;
          unusedwrite = true;
        };

        hints = {
          constantValues = true;
          parameterNames = true;
          assignVariableType = true;
          rangeVariableTypes = true;
          compositeLiteralTypes = true;
          compositeLiteralFields = true;
          functionTypeParameters = true;
        };
      };
    };
    json = {
      command = getExe pkgs.nodePackages_latest.vscode-json-languageserver;
      args = ["--stdio"];
      config.provideFormatter = true;
    };
    html = {
      command = getExe' pkgs.nodePackages_latest.vscode-langservers-extracted "html-languageserver";
      args = ["--stdio"];
      config.provideFormatter = true;
    };
    marksman = {
      command = getExe pkgs.marksman;
    };
    nixd = {
      command = getExe pkgs.nixd;
    };
    nil = {
      command = getExe pkgs.nil;
      config.nil.formatting.command = [
        "${getExe pkgs.alejandra}"
        "-q"
      ];
    };
    pylsp = {
      command = getExe' pkgs.python312Packages.python-lsp-server "pylsp";
      formatter = {
        command = getExe pkgs.python312Packages.black;
      };
    };
    pyright = {
      command = getExe' pkgs.pyright "pyright-langserver";
      args = ["--stdio"];
    };
    ruff-lsp = {
      command = "ruff-lsp";
      args = [];
      config.settings = {
        args = "--preview";
        run = "onSave";
      };
    };
    rust-analyzer = {
      config = {
        cachePriming.enable = false;
        cargo.buildScripts.enable = true;
        check.command = "clippy";
        checkOnSave.command = "clippy";
        diagnostics.experimental.enable = true;
        procMacro.enable = true;
      };
    };
    taplo = {
      command = getExe pkgs.taplo;
    };
    typescript-language-server = {
      command = getExe pkgs.nodePackages_latest.typescript-language-server;
      args = ["--stdio"];
      config = let
        inlayHints = {
          includeInlayEnumMemberValueHints = true;
          includeInlayFunctionLikeReturnTypeHints = true;
          includeInlayFunctionParameterTypeHints = true;
          includeInlayParameterNameHints = "all";
          includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          includeInlayPropertyDeclarationTypeHints = true;
          includeInlayVariableTypeHints = true;
        };
      in {
        hostInfo = "helix";

        typescript-language-server.source = {
          addMissingImports.ts = true;
          fixAll.ts = true;
          organizeImports.ts = false;
          removeUnusedImports.ts = true;
          sortImports.ts = true;
        };

        format.semicolons = "insert";

        typescript = {
          inherit inlayHints;
        };
        javascript = {
          inherit inlayHints;
        };
      };
    };
  };

  language = let
    common = {
      auto-format = true;
      indent = {
        tab-width = 2;
        unit = "  ";
      };
    };
  in
    lib.mapAttrsToList (name: value: value // {inherit name;}) {
      bash =
        common
        // {
          formatter = {
            command = getExe pkgs.shfmt;
            args = [
              "-i"
              "2"
              "--case-indent"
              "-"
            ];
          };
        };
      c = common;
      go =
        common
        // {
          language-servers = ["gopls"];
        };
      hyprlang = {
        file-types = [
          {glob = "hypr/*.conf";}
          {glob = "*.hypr.conf";}
        ];
      };
      javascript =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "typescript"];
          };
          language-servers = [
            "typescript-language-server"
            "eslint"
          ];
        };
      json =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "typescript"];
          };
          language-servers = ["json"];
        };
      markdown =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "markdown" "--prose-wrap" "never"];
          };
          language-servers = ["marksman"];
        };
      nix =
        common
        // {
          file-types = ["nix"];
          formatter = {
            command = getExe pkgs.alejandra;
          };
          language-servers = ["nixd"];
        };
      python =
        common
        // {
          file-types = ["python"];
          formatter = {
            command = "ruff";
            args = ["format" "-"];
          };
          language-servers = ["pyright"];
        };
      rust =
        common
        // {
          language-servers = ["rust-analyzer"];
        };
      toml =
        common
        // {
          language-servers = ["taplo"];
        };
      typescript = {
        scope = "source.ts";
        file-types = ["ts" "mts" "cts"];
        formatter = {
          command = getExe pkgs.nodePackages_latest.prettier;
          args = ["--parser" "typescript"];
        };
        injection-regex = "(ts|typescript)";
        language-servers = [
          "typescript-language-server"
          "eslint"
        ];
        roots = [];
        shebangs = [];
      };
    };
}
