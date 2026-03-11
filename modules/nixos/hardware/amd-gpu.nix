# AMD GPU hardware configuration with ROCm support
{ config, pkgs, lib, ... }:
{
  options.hardware.amd-gpu = {
    enable = lib.mkEnableOption "AMD GPU with ROCm support";
    enable32Bit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable 32-bit support for AMD GPU";
    };
    overrideGfxVersion = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Override GFX version for ROCm (e.g., \"12.0.1\")";
    };
  };

  config.flake.modules = lib.mkIf config.hardware.amd-gpu.enable {
    nixos.pc = {
      # Graphics configuration
      hardware.graphics = {
        enable = true;
        inherit (config.hardware.amd-gpu) enable32Bit;
      };

      # Load amdgpu module early for ROCm/Ollama GPU access
      boot.initrd.kernelModules = [ "amdgpu" ];

      # Enable OpenCL via ROCm
      hardware.amdgpu.opencl.enable = true;

      # AMD GPU firmware
      hardware.firmware = [ pkgs.linux-firmware ];
    };
  };
}
