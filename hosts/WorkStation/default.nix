{ config, pkgs, ... }: {
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

  services.my-ollama.enable = true;
  services.my-ollama.models = [ "tinyllama" ]; # Optional: customize models

  # Any other WorkStation-specific overrides go here
}
