# Edit this configuration file to define what should be installed on
# your system.

{ config, pkgs, ... }:

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

  networking.hostName = "WorkStation";
  networking.networkmanager.enable = true;

  # Timezone and Locale
  time.timeZone = "Europe/Dublin";
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

  # Desktop Environment (GNOME)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Sound (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User Account
  users.users.ruairc = {
    isNormalUser = true;
    description = "ruairc";
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" ];
    packages = with pkgs; [];
  };

  # Programs
  programs.firefox.enable = true;

  # Allow unfree packages (needed for Steam, Discord, Spotify)
  nixpkgs.config.allowUnfree = true;

  # --- MERGED SYSTEM PACKAGES ---
  environment.systemPackages = with pkgs; [
    # Essentials
    vim
    git
    wget
    curl
    yazi
    tree
    
    # Discord + Vencord
    (discord.override {
      withVencord = true;
    })

    # Spotify + Spicetify CLI
    spotify
    spicetify-cli
  ];

  # --- SPICETIFY CONFIGURATION ---
  programs.spicetify = {
    enable = true;
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
    theme = "spicetify-themes"; 
    marketplace.enable = true;
  };

  # Services
  services.my-ollama.enable = true;
  # Note: LACT is enabled in gaming.nix

  system.stateVersion = "25.11";
}
