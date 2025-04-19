{lib, ...}: let
  inherit (lib) getExe getExe';
in {
  language-server = {
    bash-language-server = {
      command = "bash-language-server";
      args = ["start"];
      environment.SHELLCHECK_ARGUMENTS = "-e SC2164";
    };
    clangd = {
      command = "clangd";
      args = ["--enable-config"];
      clangd.fallbackFlags = ["-std=c++2b"];
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
      command = "gopls";
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
    marksman = {
      command = "marksman";
      args = ["server"];
    };
    nixd = {
      command = "nixd";
      nixpkgs = {
        expr = "import <nixpkgs> {}";
      };
    };
    nil = {
      command = "nil";
      args = ["--stdio"];
      config.nil = {
        formatter.command = [
          "alejandra"
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
      command = "ruff";
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
      args = ["--stdio"];
      config.userLanguages = {
        rust = "html";
        "*.rs" = "html";
      };
    };
    taplo = {
      command = "taplo";
      args = ["lsp" "stdio"];
    };
    typescript-language-server = {
      command = "typescript-language-server";
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
            command = "shfmt";
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
            command = "prettier";
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
            command = "prettier";
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
            command = "prettier";
            args = ["--parser" "typescript"];
          };
          language-servers = [
            "typescript-language-server"
          ];
        };
      json =
        common
        // {
          formatter = {
            command = "prettier";
            args = ["--parser" "json"];
          };
          language-servers = ["json"];
        };
      markdown =
        common
        // {
          formatter = {
            command = "prettier";
            args = ["--parser" "markdown" "--prose-wrap" "never"];
          };
          language-servers = ["marksman"];
        };
      nix =
        common
        // {
          file-types = ["nix"];
          formatter = {
            command = "alejandra";
          };
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
          formatter = {
            command = "prettier";
            args = ["--parser" "scss"];
          };
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
        formatter = {
          command = "prettier";
          args = ["--parser" "typescript"];
        };
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
