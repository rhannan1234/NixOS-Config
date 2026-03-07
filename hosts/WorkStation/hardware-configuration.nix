{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1d4db494-7a66-44c2-9748-96b5a838232d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C49-C376";
    fsType = "vfat";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # ✅ Set state version (MUST match flake.nix)
  system.stateVersion = "25.11";

  # ========== AMD GPU Support ==========
  
  # ✅ REMOVED: hardware.graphics (now ONLY in gaming.nix)

  # AMD GPU drivers
  hardware.amdgpu.initrd.enable = true;

  # Enable firmware for AMD GPU
  hardware.enableRedistributableFirmware = true;

  # Kernel parameters for AMD GPU stability
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.sg_display=0"
  ];

  # Add ROCm libraries to system packages
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.rocm-smi
    vulkan-loader
    vulkan-validation-layers
  ];

  # Set ROCm environment variables
  environment.variables = {
    HSA_OVERRIDE_GFX_VERSION = "11.0.0";
    ROCM_PATH = "${pkgs.rocmPackages.clr}";
  };
}