{ config, pkgs, lib, ... }:

{
  options.services.my-ollama = {
    enable = lib.mkEnableOption "Enable Ollama";
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "qwen2.5:7b" ];
      description = "Models to pull.";
    };
  };

  config = lib.mkIf config.services.my-ollama.enable {
    
    services.ollama = {
      enable = true;
      openFirewall = false;
      package = pkgs.ollama-rocm; 
      
      # Let Ollama handle its own startup. 
      # We will create a ONESHOT service to pull models ONLY after ollama is running.
    };

    users.users.ruairc.extraGroups = [ "ollama" ];

    # Robust Model Puller Service
    systemd.services.ollama-pull-models = {
      description = "Pull Ollama models after service starts";
      wantedBy = [ "multi-user.target" ];
      after = [ "ollama.service" "network-online.target" ];
      
      # Ensure it only runs once per boot/update
      serviceConfig = {
        Type = "oneshot";
        User = "ruairc"; # Run as your user so permissions are correct
        Group = "users";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull qwen2.5:7b'";
        # If you have multiple models, chain them:
        # ExecStart = [
        #   "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull qwen2.5:7b'"
        #   "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull nomic-embed-text'"
        # ];
      };
      
      # If the pull fails, don't fail the whole boot, just log it
      unitConfig = {
        FailureAction = "none";
      };
    };
  };
}

