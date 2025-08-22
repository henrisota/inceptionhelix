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
    cmake-language-server = {
      command = getExe pkgs.cmake-language-server;
    };
    eslint = {
      command = "eslint-languageserver";
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
          assignVariableTypes = true;
          compositeLiteralTypes = true;
          compositeLiteralFields = true;
          constantValues = true;
          functionTypeParameters = true;
          parameterNames = true;
          rangeVariableTypes = true;
        };
      };
    };
    nixd = {
      command = getExe pkgs.nixd;
      nixpkgs = {
        expr = "import <nixpkgs> {}";
      };
    };
    nil = {
      command = getExe pkgs.nil;
      args = ["--stdio"];
      config.nil = {
        formatter.command = [
          (getExe pkgs.alejandra)
          "-q"
        ];
        nix.flake.autoEvalInputs = true;
      };
    };
    pylsp = {
      command = "pylsp";
    };
    pyright = {
      command = "pyright-langserver";
      args = ["--stdio"];
    };
    ruff = {
      command = getExe pkgs.ruff;
      args = ["server"];
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
          bindingModeHints.enable = false;
          closingBraceHints.minLines = 10;
          closureReturnTypeHints.enable = "with_block";
          closureCaptureHints.enable = true;
          discriminantHints.enable = "fieldless";
          lifetimeElisionHints.enable = "skip_trivial";
          maxLength = 25;
          typeHints.hideClosureInitialization = false;
        };
        lens = {
          references = true;
          methodReferences = true;
        };
        procMacro.enable = true;
      };
    };
    tailwindcss-ls = {
      command = getExe pkgs.tailwindcss-language-server;
      args = ["--stdio"];
      config.userLanguages = {
        rust = "html";
        "*.rs" = "html";
      };
    };
    taplo = {
      command = getExe pkgs.taplo;
      args = ["lsp" "stdio"];
    };
    typescript-language-server = {
      command = getExe pkgs.nodePackages.typescript-language-server;
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
    vscode-css-language-server = {
      command = getExe' pkgs.nodePackages.vscode-langservers-extracted "vscode-css-language-server";
      args = ["--stdio"];
      config = {
        provideFormatter = true;
        css.validate.enable = true;
        scss.validate.enable = true;
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
    prettier = language: overrides: {
      command = getExe pkgs.nodePackages.prettier;
      args = ["--parser" language] ++ (overrides.args or []);
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
          formatter = prettier "css" {};
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
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
          formatter = prettier "html" {};
          language-servers = ["vscode-html-language-server" "superhtml" "tailwindcss-ls"];
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
          formatter = prettier "typescript" {};
          language-servers = [
            "typescript-language-server"
          ];
        };
      json =
        common
        // {
          formatter = prettier "json" {};
        };
      markdown =
        common
        // {
          formatter = prettier "markdown" {args = ["--prose-wrap" "never"];};
        };
      nix =
        common
        // {
          file-types = ["nix"];
          formatter = {
            command = "alejandra";
          };
          roots = ["flake.nix"];
          language-servers = ["nil" "nixd"];
        };
      python =
        common
        // {
          file-types = ["python"];
          formatter = {
            command = "ruff";
            args = ["format" "-"];
          };
          language-servers = ["ruff" "pyright"];
        };
      rust =
        common
        // {
          language-servers = ["rust-analyzer"];
        };
      scss =
        common
        // {
          formatter = prettier "scss" {};
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
        };
      toml =
        common
        // {
          formatter = {
            command = "taplo";
            args = ["format" "-"];
          };
          language-servers = ["taplo"];
        };
      typescript = {
        formatter = prettier "typescript" {};
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
      };
    };
}
