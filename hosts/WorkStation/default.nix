{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    # Shared modules
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/dev-tools.nix
    ../../modules/multimedia.nix

    # WorkStation-specific modules
    ../../modules/gaming.nix
    
    # AI/ML stack (modular)
    ../../modules/nixos/hardware/amd-gpu.nix
    ../../modules/nixos/services/ollama.nix
    ../../modules/nixos/services/open-webui.nix
    ../../modules/nixos/services/ollama-models.nix
    ../../modules/nixos/programs/ollama-tools.nix
  ];

  networking.hostName = "WorkStation";

  # Register Home Manager configuration
  configurations.home-manager.workstation = {
    module = ../../modules/home-manager;
  };

  # AMD GPU with ROCm support
  hardware.amd-gpu = {
    enable = true;
    enable32Bit = true;
    overrideGfxVersion = "12.0.1";
  };

  # Ollama service with ROCm
  services.ollama-custom = {
    enable = true;
    rocmOverrideGfx = "12.0.1";
    keepAlive = "2m";
  };

  # Open WebUI
  services.open-webui-custom = {
    enable = true;
    port = 8080;
    host = "127.0.0.1";
    keepAlive = "2m";
  };

  # Auto-pull models
  services.ollama-models = {
    enable = true;
    models = [ "tinyllama" ];
  };

  # CLI helper tools
  programs.ollama-tools.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}