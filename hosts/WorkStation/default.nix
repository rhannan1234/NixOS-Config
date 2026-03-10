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

  # Ollama configuration
  services.my-ollama.enable = true;
  services.my-ollama.models = [ "tinyllama" ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}