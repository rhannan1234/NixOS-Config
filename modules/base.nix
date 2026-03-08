{ config, pkgs, ... }: {
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d --max-n-generations 10";
  };
  
  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  networking.networkmanager.enable = true;

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

  # ✅ Zram Swap - compressed RAM swap (prevents OOM during builds)
  zramSwap = {
    enable = true;
    algorithm = "zstd";        # Better compression than default
    priority = 100;            # Higher priority than disk swap
    memoryPercent = 50;        # Use up to 50% of RAM (~15GB on your 30GB system)
  };

  # ✅ ALL user groups defined in ONE place
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