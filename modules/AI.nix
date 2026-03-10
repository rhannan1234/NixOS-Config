# AI/ML configuration (Ollama, Open WebUI)
{ config, pkgs, lib, ... }:
{
  options.services.my-ollama = {
    enable = lib.mkEnableOption "Ollama service";
    models = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "tinyllama" ];
      description = "List of Ollama models to pull.";
    };
  };

  config.flake.modules = {
    nixos.pc = lib.mkIf config.services.my-ollama.enable {
      # AMD GPU / ROCm setup
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # Load amdgpu module early for ROCm/Ollama GPU access
      boot.initrd.kernelModules = [ "amdgpu" ];

      # Enable OpenCL via ROCm
      hardware.amdgpu.opencl.enable = true;

      # Ollama with ROCm acceleration
      services.ollama = {
        enable = true;
        openFirewall = false;
        package = pkgs.ollama-rocm;
        rocmOverrideGfx = "12.0.1";  # Force RDNA4/gfx1201 target
        environmentVariables = {
          HCC_AMDGPU_TARGET = "gfx1201";
          OLLAMA_KEEP_ALIVE = "2m";
        };
      };

      # Open WebUI integration
      services.open-webui = {
        enable = true;
        port = 8080;
        host = "127.0.0.1";
        openFirewall = false;
        environment = {
          OLLAMA_KEEP_ALIVE = "2m";
        };
      };

      # CLI helper scripts
      environment.systemPackages = with pkgs; [
        # Unload all models from VRAM
        (writeShellScriptBin "ollama-unload" ''
          #!/usr/bin/env bash
          echo "Unloading all Ollama models from VRAM..."
          curl -s http://localhost:11434/api/generate -d '{"model": ""}' > /dev/null
          if [ $? -eq 0 ]; then
            echo "All models unloaded!"
          else
            echo "Failed. Is Ollama running? (systemctl status ollama)"
            exit 1
          fi
        '')

        # Check loaded models
        (writeShellScriptBin "ollama-status" ''
          #!/usr/bin/env bash
          echo "Currently Loaded Models:"
          curl -s http://localhost:11434/api/ps | jq '.models[] | {name, size, expires_at}'
          if [ $? -ne 0 ]; then
            echo "Cannot connect to Ollama"
            exit 1
          fi
        '')
      ];

      # Model puller service
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
          ExecStart = "${pkgs.bash}/bin/bash -c '${config.services.ollama.package}/bin/ollama pull ${lib.concatStringsSep " " config.services.my-ollama.models}'";
          Environment = [
            "HCC_AMDGPU_TARGET=gfx1201"
            "HSA_OVERRIDE_GFX_VERSION=12.0.1"
          ];
        };

        unitConfig = {
          FailureAction = "none";
        };
      };

      # AMD GPU firmware
      hardware.firmware = [ pkgs.linux-firmware ];
    };
  };
}
