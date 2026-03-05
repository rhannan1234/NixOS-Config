{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "workstation";

  # Enable Home Manager as a NixOS Module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.youruser = import ../../modules/home;
    
    # Optional: Pass extra arguments to home manager
    # extraSpecialArgs = { inherit inputs; };
  };

  # Workstation specific overrides
  # e.g., Higher performance CPU settings, specific GPU drivers
  boot.kernelParams = [ "quiet" ];
}
