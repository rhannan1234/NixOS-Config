{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    
    # Import shared modules
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/dev-tools.nix
    ../../modules/multimedia.nix
    
    # NOTE: gaming.nix and services.nix are NOT imported here
  ];

  # Ensure hostname is set
  networking.hostName = "Laptop";

  # Laptop-specific overrides (e.g., power management, touchpad)
  # services.tlp.enable = true; 
}
