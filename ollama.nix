{ config, pkgs, lib, ... }:

{
  # Define options for this module (optional, but good practice)
  options.services.my-ollama = {
    enable = lib.mkEnableOption "Enable Ollama with TinyLlama";
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "tinyllama" ];
      description = "List of models to pull on startup.";
    };
  };

  # The actual configuration implementation
  config = lib.mkIf config.services.my-ollama.enable {
    
    # 1. Enable the Ollama Service
    services.ollama = {
      enable = true;
      # Optional: Load models into GPU memory automatically if you have VRAM
      # acceleration = "cuda"; # Uncomment if you have an NVIDIA GPU
      acceleration = "rocm"; # Uncomment if you have an AMD GPU
      
      # Allow your user to access the ollama socket without sudo
      openFirewall = true; 
    };

    # 2. Add your user to the 'ollama' group so you can run 'ollama run' freely
    users.users.ruairc.extraGroups = [ "ollama" ];

    # 3. Automatically pull models on system activation
    # This runs every time you rebuild, ensuring the model exists
    systemd.services.ollama-init = {
      description = "Pull Ollama models";
      wantedBy = [ "multi-user.target" ];
      after = [ "ollama.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = "ollama";
        Group = "ollama";
      };
      script = ''
        ${pkgs.ollama}/bin/ollama pull tinyllama
        # You can add more models here if needed:
        # ${pkgs.ollama}/bin/ollama pull llama3
      '';
    };
  };
}

