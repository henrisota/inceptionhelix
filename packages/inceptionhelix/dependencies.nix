{
  lib,
  pkgs,
  ...
}:
with pkgs; let
  debuggers = [
    # C / C++
    lldb
    # Go
    delve
  ];

  formatters = [
    # Go
    delve
    # Nix
    alejandra
  ];

  languageServers = [
    # Bash
    nodePackages_latest.bash-language-server
    # C / C++
    clang-tools
    cmake-language-server
    # Dockerfile
    dockerfile-language-server-nodejs
    # Go
    gopls
    golangci-lint-langserver
    # Helm
    helm-ls
    # Java
    jdt-language-server
    # JSON
    nodePackages_latest.vscode-json-languageserver
    # Kotlin
    kotlin-language-server
    # Lua
    lua-language-server
    # Markdown
    marksman
    # Nix
    nil
    nixd
    # Python
    pyright
    ruff
    ruff-lsp
    # Rust
    rust-analyzer
    # Terraform
    terraform-ls
    # TOML
    taplo
    # TypeScript
    nodePackages_latest.typescript-language-server
    # YAML
    yaml-language-server
  ];
in
  lib.lists.unique (debuggers ++ formatters ++ languageServers ++ [ripgrep])
