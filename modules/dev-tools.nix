# Development tools configuration
{ config, pkgs, ... }:
{
  flake.modules = {
    nixos.pc = {
      environment.systemPackages = with pkgs; [
        # Core CLI tools
        vim
        git
        wget
        curl
        yazi
        tree
        unzip
        jq

        # Languages and runtimes
        python3
        go
        nixfmt-classic

        # VS Code with extensions
        (pkgs.vscode-with-extensions.override {
          vscodeExtensions = with pkgs.vscode-extensions; [
            # NixOS support
            bbenoist.nix

            # Python support
            ms-python.python
            ms-python.vscode-pylance

            # Go support
            golang.go

            # General quality of life
            editorconfig.editorconfig
            esbenp.prettier-vscode
            rust-lang.rust-analyzer
          ];
        })
      ];
    };
  };
}
