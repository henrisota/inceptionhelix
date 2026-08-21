{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) getExe;

  lsp = inputs.inceptionlsp.lib;
in {
  language-server = lsp.toHelix pkgs [
    "gopls"
    "nil"
    "nixd"
    "pyright"
    "ruff"
    "rust-analyzer"
    "sqls"
    "superhtml"
    "tailwindcss-ls"
    "taplo"
    "typescript-language-server"
    "vscode-css-language-server"
    "vscode-html-language-server"
  ];

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
      command = getExe pkgs.prettier;
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
      sql =
        common
        // {
          formatter = {
            command = getExe pkgs.sqlfluff;
            args = ["format" "--dialect" "ansi" "-"];
          };
          language-servers = ["sqls"];
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
