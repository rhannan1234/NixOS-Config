{ config, lib, pkgs, modulesPath, ...}:

{
  imports = 
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  fileSystems."/" = {
    device = "dev/disk/by-uuid/1d4db494-7a66-44c2-9748-96b5a838232d";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C49-C376";
    fsType = "vfat";
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
