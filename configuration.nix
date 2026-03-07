# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, nixpkgs-old, ... }:


{
  # Enable Flakes and Nix Command globally
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  
  # Limit boot entries to prevent filling up the small EFI partition
  boot.loader.systemd-boot.configurationLimit = 5;

  # Automatic garbage collection to clean up old generations
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d --max-n-generations 10";
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./ollama.nix
      ./gaming.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "WorkStation"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Dublin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "en_IE.UTF-8";
    LC_TELEPHONE = "en_IE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.ruairc = {
    isNormalUser = true;
    description = "ruairc";
    # Added video, render, input for GPU control (LACT) and Gaming
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" ];
    packages = with pkgs; [];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages (Required for Steam, Discord, Spotify)
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    git
    wget
    curl
    yazi
    tree
    
    # Discord + Vencord (Wrapped with Vencord pre-injected)
    (discord.override {
      withVencord = true;
    })

    # Spicetify CLI (uses current version)
    spicetify-cli
    
    # SPOTIFY: DOWNGRADED to 1.2.14 using nixpkgs-old for Spicetify compatibility
    (nixpkgs-old.legacyPackages.x86_64-linux.spotify)
  ];

  # --- SPICETIFY CONFIGURATION ---
  programs.spicetify = {
    enable = true;
    # We manage extensions manually via CLI to avoid API breakage
  };

  # Services
  services.my-ollama.enable = true;
  # Note: services.lact.enable is handled inside ./gaming.nix

  system.stateVersion = "25.11"; # Did you read the comment?
}
