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
  
  # AMD GPU drivers
  hardware.amdgpu.initrd.enable = true;

  # Enable firmware for AMD GPU
  hardware.enableRedistributableFirmware = true;

  # Kernel parameters for AMD GPU stability (add back if needed)
  boot.kernelParams = [
    "amdgpu.runpm=0"
  ];
}