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
    ../../modules/AI.nix
  ];

  networking.hostName = "WorkStation";

  # Register Home Manager configuration
  configurations.home-manager.workstation = {
    module = ../../modules/home-manager;
  };

  # Ollama configuration
  services.my-ollama.enable = true;
  services.my-ollama.models = [ "tinyllama" ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}