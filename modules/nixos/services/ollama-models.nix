# Ollama model puller systemd service
{ config, pkgs, lib, ... }:
{
  options.services.ollama-models = {
    enable = lib.mkEnableOption "Automatic Ollama model pulling";
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "tinyllama" ];
      description = "List of Ollama models to pull automatically";
    };
  };

  config.flake.modules = lib.mkIf config.services.ollama-models.enable {
    nixos.pc = {
      systemd.services.ollama-pull-models = {
        description = "Pull Ollama models after service starts";
        wantedBy = [ "multi-user.target" ];
        after = [ "ollama.service" "network-online.target" ];
        requires = [ "ollama.service" ];
        wants = [ "network-online.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = config.username;
          Group = "users";
          RemainAfterExit = true;
          ExecStart = "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull ${lib.concatStringsSep " " config.services.ollama-models.models}'";
          Environment = [
            "HCC_AMDGPU_TARGET=gfx1201"
            "HSA_OVERRIDE_GFX_VERSION=12.0.1"
          ];
        };

        unitConfig = {
          FailureAction = "none";
        };
      };
    };
  };
}
