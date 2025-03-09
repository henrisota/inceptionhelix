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
      args = ["--enable-config"];
      clangd.fallbackFlags = ["-std=c++2b"];
    };
    eslint = {
      command = getExe' pkgs.nodePackages_latest.vscode-langservers-extracted "eslint-languageserver";
      args = ["--stdio"];
      config = {
        codeAction = {
          disableRuleComment = {
            enable = true;
            location = "separateLine";
          };
          mode = "all";
          showDocumentation.enable = true;
        };
        experimental = {};
        format = false;
        nodePath = "";
        onIgnoredFiles = "off";
        packageManages = "npm";
        problems.shortenToSingleLine = false;
        run = "onType";
        useESLintClass = false;
        validate = "on";
        workingDirectory.mode = "auto";
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
    html = {
      command = getExe' pkgs.nodePackages_latest.vscode-langservers-extracted "html-languageserver";
      args = ["--stdio"];
      config.provideFormatter = true;
    };
    json = {
      command = getExe pkgs.nodePackages_latest.vscode-json-languageserver;
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
      args = ["--stdio"];
      config.nil = {
        formatter.command = [
          "${getExe pkgs.alejandra}"
          "-q"
        ];
        nix.flake.autoEvalInputs = true;
      };
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
        cargo = {
          buildScripts.enable = true;
          loadOutDirsFromCheck = true;
        };
        check.command = "clippy";
        checkOnSave.command = "clippy";
        completion.autoimport.enable = true;
        diagnostics = {
          disabled = ["unresolved-proc-macro"];
          experimental.enable = true;
        };
        experimental.procAttrMacros = true;
        files = {
          excludeDirs = ["node_modules"];
        };
        inlayHints = {
          maxLength = 25;
          discriminantHints.enable = true;
          closureReturnTypeHints.enable = true;
          closureCaptureHints.enable = true;
        };
        lens = {
          references = true;
          methodReferences = true;
        };
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
      auto-pairs = {
        "(" = ")";
        "{" = "}";
        "[" = "]";
        "<" = ">";
        "'" = "'";
        "\"" = "\"";
      };
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
              "--posix"
              "--apply-ignore"
              "--case-indent"
              "--space-redirects"
              "--write"
              "-"
            ];
          };
        };
      c = common;
      css =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "css"];
          };
        };
      git-commit =
        common
        // {
          comment-token = "#";
          file-types = ["COMMIT_EDITMSG"];
          roots = [];
        };
      go =
        common
        // {
          language-servers = ["gopls"];
        };
      html =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "html"];
          };
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
            args = ["--parser" "json"];
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
          language-servers = ["nil" "nixd"];
          roots = ["flake.nix"];
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
          roots = ["pyproject.toml" "setup.py" "Poetry.lock"];
        };
      rust =
        common
        // {
          language-servers = ["rust-analyzer"];
        };
      scss =
        common
        // {
          formatter = {
            command = getExe pkgs.nodePackages_latest.prettier;
            args = ["--parser" "scss"];
          };
        };
      toml =
        common
        // {
          formatter = {
            command = getExe pkgs.taplo;
            args = ["format" "-"];
          };
          language-servers = ["taplo"];
        };
      typescript = {
        file-types = ["ts" "mts" "cts"];
        formatter = {
          command = getExe pkgs.nodePackages_latest.prettier;
          args = ["--parser" "typescript"];
        };
        injection-regex = "(ts|typescript)";
        language-servers = [
          {
            name = "typescript-language-server";
            except-features = ["format"];
          }
          {
            name = "prettier";
            only-features = ["format"];
          }
        ];
        roots = [];
        shebangs = [];
      };
    };
}
# [[language]]
# name = "json"
# formatter = { command = 'prettier', args = ["--parser", "json"] }
# auto-format = true
# [[language]]
# name = "css"
# formatter = { command = 'prettier', args = ["--parser", "css"] }
# auto-format = true
# [[language]]
# name = "javascript"
# formatter = { command = 'prettier', args = ["--parser", "typescript"] }
# auto-format = true
# [[language]]
# name = "typescript"
# formatter = { command = 'prettier', args = ["--parser", "typescript"] }
# auto-format = true
# [[language]]
# name = "markdown"
# formatter = { command = 'prettier', args = ["--parser", "markdown"] }
# auto-format = true
# [[language]]
# name = "hcl"
# formatter = { command = 'terraform', args = ["fmt", "-"] }
# auto-format = true
# [[language]]
# name = "tfvars"
# formatter = { command = 'terraform', args = ["fmt", "-"] }
# auto-format = true

