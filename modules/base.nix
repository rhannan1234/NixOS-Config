{ config, pkgs, ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collection: weekly, keep last 10 generations, delete older than 7 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d --max-n-generations 10";
  };

  # Bootloader: systemd-boot with EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Networking via NetworkManager
  networking.networkmanager.enable = true;

  # Locale and timezone
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

  # Zram Swap: compressed RAM (fast, preferred)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 100;
    memoryPercent = 50;
  };

  # SSD Swap File: backup swap (slower but prevents OOM)
  systemd.tmpfiles.rules = [
    "f /swapfile 0600 root root 16G"
  ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16384;  # 16GB in MB
      priority = 10;  # Lower than zram's 100
    }
  ];

  # User configuration
  users.users.ruairc = {
    isNormalUser = true;
    description = "ruairc";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
      "input"
      "ollama"
    ];
    packages = with pkgs; [];
  };
}