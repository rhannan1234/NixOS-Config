# Host configurations - disabled in favor of auto-discovery in flake.nix
# The flake.nix file automatically discovers host directories and creates
# configurations using config.configurations.nixos
{ lib, config, ... }: {
  # This module is kept for compatibility but doesn't define conflicting options
  # Host configurations are now managed directly in flake.nix via:
  # config.configurations.nixos = lib.mapAttrs' ...
}
