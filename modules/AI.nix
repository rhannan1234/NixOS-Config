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
    
    # === AMD GPU / ROCm Setup ===
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    
    # Load amdgpu early for ROCm/Ollama GPU access
    boot.initrd.kernelModules = [ "amdgpu" ];
    
    # Optional: Enable OpenCL via ROCm if needed for other apps
    hardware.amdgpu.opencl.enable = true;
    
    # === Ollama with ROCm Acceleration ===
    services.ollama = {
      enable = true;
      openFirewall = false;
      # Use ROCm-enabled package
      package = pkgs.ollama-rocm;
      # Force RDNA4/gfx1201 target for RX 9070 XT
      rocmOverrideGfx = "12.0.1";
      # Auto-unload models after 2 minutes of idle (saves VRAM)
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1201";
        OLLAMA_KEEP_ALIVE = "2m";
      };
    };

    # === Open WebUI Integration ===
    services.open-webui = {
      enable = true;
      port = 8080;
      host = "127.0.0.1";
      openFirewall = false;
      # Match Ollama's keep-alive setting
      environment = {
        OLLAMA_KEEP_ALIVE = "2m";
      };
    };

    # === CLI Helper Scripts ===
    environment.systemPackages = with pkgs; [
      # Unload all models from VRAM instantly
      (writeShellScriptBin "ollama-unload" ''
        #!/usr/bin/env bash
        echo "🧹 Unloading all Ollama models from VRAM..."
        curl -s http://localhost:11434/api/generate -d '{"model": ""}' > /dev/null
        if [ $? -eq 0 ]; then
          echo "✅ All models unloaded!"
        else
          echo "❌ Failed. Is Ollama running? (systemctl status ollama)"
          exit 1
        fi
      '')
      
      # Check which models are currently loaded in VRAM
      (writeShellScriptBin "ollama-status" ''
        #!/usr/bin/env bash
        echo "📊 Currently Loaded Models:"
        curl -s http://localhost:11434/api/ps | jq '.models[] | {name, size, expires_at}'
        if [ $? -ne 0 ]; then
          echo "❌ Cannot connect to Ollama"
          exit 1
        fi
      '')
    ];

    # === Model Puller Service (updated for ROCm) ===
    systemd.services.ollama-pull-models = {
      description = "Pull Ollama models after service starts";
      wantedBy = [ "multi-user.target" ];
      after = [ "ollama.service" "network-online.target" ];
      requires = [ "ollama.service" ];
      wants = [ "network-online.target" ];
      
      serviceConfig = {
        Type = "oneshot";
        User = "ruairc";
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
    
    # === Optional: Add firmware for AMD GPU ===
    hardware.firmware = [ pkgs.linux-firmware ];
  };
}