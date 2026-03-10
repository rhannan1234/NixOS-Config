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

```
.
├── flake.nix              # Main flake configuration
├── home.nix               # Home Manager configuration
├── modules/
│   ├── multimedia.nix     # Multimedia apps (Spotify, OBS, etc.)
│   └── ...                # Other module configurations
└── README.md
```

## License

MIT
