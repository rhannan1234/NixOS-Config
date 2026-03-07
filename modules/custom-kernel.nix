{ config, pkgs, lib, ... }:

let
  # HDMI FRL Patched Kernel
  linux-hdmi-frl = pkgs.linux.override {
    src = pkgs.fetchFromGitHub {
      owner = "mkopec";
      repo = "linux";
      rev = "hdmi_frl";
      # Get the latest commit hash from the repo
      sha256 = "sha256-0330f5db4xnkh1rdgcpch0nicchzd5igcl6w0dzwj9afnl28lvh0";
    };
  };
in
{
  # Use the custom kernel
  boot.kernelPackages = pkgs.linuxPackagesFor linux-hdmi-frl;
  
  # Enable debugfs for HDMI status monitoring
  boot.kernelParams = [
    "amdgpu.runpm=0"
    "amdgpu.sg_display=0"
    "amdgpu.dcdebugmask=0x10"
    "drm.debug=0xe"  # Enable DRM debug output
  ];
  
  # Mount debugfs for monitoring
  boot.extraModprobeConfig = ''
    options amdgpu dcfeaturemask=0xffffffff
  '';
}
