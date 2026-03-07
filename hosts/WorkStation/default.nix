{ config, pkgs, nixpkgs-old, ... }: {
  imports = [
    ./hardware-configuration.nix
    
    # Import shared modules
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/dev-tools.nix
    ../../modules/multimedia.nix
    
    # WorkStation ONLY modules
    ../../modules/gaming.nix
    ../../modules/services.nix # Ollama
  ];

  # Ensure hostname is set
  networking.hostName = "WorkStation";

  # Any other WorkStation-specific overrides go here
}
