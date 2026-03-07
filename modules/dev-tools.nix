{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # --- Core CLI Tools ---
    vim
    git
    wget
    curl
    yazi
    tree
    unzip
    
    # --- Languages & Runtimes ---
    python3
    go
    nixfmt-classic # Modern Nix formatter (replaces nixfmt)
    
    # --- Spicetify (kept from previous config) ---
    spicetify-cli

    # --- VS Code with Extensions ---
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        # NixOS Support
        bbenoist.nix
        
        # Python Support
        ms-python.python
        ms-python.vscode-pylance
        
        # Go Support
        golang.go
        
        # General Quality of Life
        editorconfig.editorconfig
        esbenp.prettier-vscode
        rust-lang.rust-analyzer # Optional: helpful even if not writing Rust
      ];
    })
  ];

  # Enable shell completions for these tools
  programs.bash.completionEnable = true;
  programs.zsh.completionEnable = true;
}
