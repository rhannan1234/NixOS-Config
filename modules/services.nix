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
      # Force RDNA4/gfx1201 target for RX 9070 XT [[11]]
      rocmOverrideGfx = "12.0.1";
      # Optional: Additional env vars if needed
      environmentVariables = {
        HCC_AMDGPU_TARGET = "gfx1201";
      };
    };

    # === Open WebUI Integration ===
    services.open-webui = {
      enable = true;
      port = 8080;  # Default port, change if needed
      host = "127.0.0.1";  # Bind to localhost; use "0.0.0.0" for network access
      openFirewall = false;  # Set true if accessing remotely
    };

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
        # Ensure ROCm env vars are available during model pull
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