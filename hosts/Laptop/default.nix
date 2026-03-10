{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    # Shared modules
    ../../modules/base.nix
    ../../modules/desktop.nix
    ../../modules/dev-tools.nix
    ../../modules/multimedia.nix
  ];

  networking.hostName = "Laptop";

  # Laptop-specific configurations (e.g., power management)
  # services.tlp.enable = true;
}
