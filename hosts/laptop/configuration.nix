{ config, pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  networking.hostName = "laptop";

  # Enable Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.youruser = import ../../modules/home;
  };

  # Laptop specific overrides
  # e.g., Power management, TLP, lower screen brightness defaults
  services.tlp.enable = true;
}
