{ config, pkgs, lib, ... }:

{
  options.services.my-ollama = {
    enable = lib.mkEnableOption "Enable Ollama";
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "tinyllama" ];
      description = "Models to pull.";
    };
  };

  config = lib.mkIf config.services.my-ollama.enable {
    
    services.ollama = {
      enable = true;
      openFirewall = false;
      package = pkgs.ollama;
    };

    # Model Puller Service
    systemd.services.ollama-pull-models = {
      description = "Pull Ollama models after service starts";
      wantedBy = [ "multi-user.target" ];
      after = [ "ollama.service" "network-online.target" ];
      requires = [ "ollama.service" ];
      wants = ["network-online.target" ];
      
      serviceConfig = {
        Type = "oneshot";
        User = "ruairc";
        Group = "users";
        RemainAfterExit = true;
        ExecStart = "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull ${lib.concatStringsSep " " config.services.my-ollama.models}'";
      };
      
      unitConfig = {
        FailureAction = "none";
      };
    };
  };
}