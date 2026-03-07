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
    ../../modules/AI.nix

    # ✅ REMOVE THIS LINE:
    # ../../modules/custom-kernel.nix
  ];

  services.my-ollama.enable = true;
  services.my-ollama.models = [ "tinyllama" ];

  environment.systemPackages = with pkgs; [
    ntfs3g
  ];
}