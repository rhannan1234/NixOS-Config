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
    ../../modules/services.nix

    ../../modules/custom-kernel.nix
  ];

  # Enable Ollama
  services.my-ollama.enable = true;
  services.my-ollama.models = [ "tinyllama" ];

  # ✅ Add ntfs3g for Windows partition support (WorkStation only)
  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}