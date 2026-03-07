{ config, lib, pkgs, modulesPath, ... }:

let
  # HDMI FRL Patched Kernel
  linux-hdmi-frl = pkgs.linux.override {
    src = pkgs.fetchFromGitHub {
      owner = "mkopec";
      repo = "linux";
      rev = "hdmi_frl";
      # ✅ FIX: Remove "sha256-" prefix
      sha256 = "0330f5db4xnkh1rdgcpch0nicchzd5igcl6w0dzwj9afnl28lvh0";
    };
  };
in
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

  # ✅ Windows Partition Auto-Mount
  fileSystems."/mnt/windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs-3g";
    options = [ 
      "defaults" 
      "uid=1000" 
      "gid=100" 
      "umask=022"
    ];
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.stateVersion = "25.11";

  # ========== AMD GPU Support ==========
  
  hardware.amdgpu.initrd.enable = true;
  hardware.enableRedistributableFirmware = true;

  # ✅ CUSTOM KERNEL with mkForce
  boot.kernelPackages = lib.mkForce (pkgs.linuxPackagesFor linux-hdmi-frl);

  # ✅ FRL-specific kernel parameters
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.sg_display=0"
    "amdgpu.noretry=0"
    "amdgpu.vm_fault_stop=0"
    "amdgpu.gpu_recovery=1"
    # ✅ HDMI FRL specific
    "amdgpu.frl=1"
    "amdgpu.link_speed=3"
    "drm.debug=0xe"
  ];

  systemd.services.fix-boot-seed = {
    description = "Fix boot random seed permissions";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.coreutils}/bin/chmod 600 /boot/loader/random-seed";
      RemainAfterExit = true;
    };
  };
}