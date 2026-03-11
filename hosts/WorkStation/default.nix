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
    module = ../../modules/home-manager.nix;
  };

  # AMD GPU with ROCm support
  hardware.amd-gpu.enable = true;
  hardware.amd-gpu.enable32Bit = true;
  hardware.amd-gpu.overrideGfxVersion = "12.0.1";

  # Ollama service with ROCm
  services.ollama-custom.enable = true;
  services.ollama-custom.rocmOverrideGfx = "12.0.1";
  services.ollama-custom.keepAlive = "2m";

  # Open WebUI
  services.open-webui-custom.enable = true;
  services.open-webui-custom.port = 8080;
  services.open-webui-custom.host = "127.0.0.1";
  services.open-webui-custom.keepAlive = "2m";

  # Auto-pull models
  services.ollama-models.enable = true;
  services.ollama-models.models = [ "tinyllama" ];

  # CLI helper tools
  programs.ollama-tools.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}
