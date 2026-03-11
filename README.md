# My NixOS-Config

A flake-based NixOS configuration for my workstation.

## Features

- **Desktop Environment**: GNOME with customizations
- **Applications**:
  - Vesktop (Discord client with Vencord)
  - Brave Browser
  - Obsidian
  - OBS Studio
  - Spotify with Spicetify theming
- **Spicetify Configuration**:
  - Theme: Catppuccin Mocha
  - Color Scheme: Mocha
  - Extensions: adblock, hidePodcasts, shuffle

## Quick Start

### Rebuild System

```bash
rebuildall
```

This script will:
1. Stage any configuration changes
2. Commit them to git
3. Rebuild the NixOS system

### Apply Spicetify Theme

After rebuilding, apply the Spotify theme:

```bash
spicetify apply
```

## Structure

Following the **dendritic pattern** with **flake-parts**:

```
.
├── flake.nix                    # Main flake entry point
├── hosts/
│   ├── Laptop/
│   │   ├── default.nix          # Laptop NixOS configuration
│   │   └── hardware-configuration.nix
│   └── WorkStation/
│       ├── default.nix          # WorkStation NixOS configuration
│       └── hardware-configuration.nix
├── modules/
│   ├── home-manager/
│   │   └── default.nix          # Home Manager configuration (shared)
│   ├── base.nix                 # Base system settings
│   ├── desktop.nix              # Desktop environment
│   ├── dev-tools.nix            # Development tools
│   ├── multimedia.nix           # Multimedia apps (Spotify, OBS, etc.)
│   ├── gaming.nix               # Gaming-related packages
│   ├── AI.nix                   # AI/ML services (Ollama, Open WebUI)
│   ├── meta.nix                 # Top-level options (username, hostname)
│   ├── systems.nix              # Supported system architectures
│   └── flake-parts.nix          # Flake-parts integration
├── scripts/
│   └── rebuildall               # Rebuild helper script
└── README.md
```

### Key Concepts

- **Dendritic Pattern**: Every `.nix` file (except `flake.nix`) is a flake-parts module
- **Module Registration**: Host configurations declare their Home Manager configs via `configurations.home-manager.<name>`
- **Shared Configurations**: Home Manager config lives in `modules/home-manager/` and is referenced by multiple hosts

## License

MIT
