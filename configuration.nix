{ config, pkgs, nixpkgs-old, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    # Import our new modular files
    ./modules/base.nix
    ./modules/desktop.nix
    ./modules/gaming.nix
    ./modules/dev-tools.nix
    ./modules/services.nix
    
    # Special handling for Spotify (Downgrade) & Discord
    # We keep these inline because they need special logic (overlays/imports)
  ];

  # --- SPECIAL PACKAGES (Spotify Downgrade & Discord) ---
  environment.systemPackages = with pkgs; [
    # Discord with Vencord
    (discord.override { withVencord = true; })
    
    # SPOTIFY: Downgraded version from nixpkgs-old
    (let 
       pkgs-old = import nixpkgs-old { 
         system = "x86_64-linux"; 
         config = { allowUnfree = true; }; 
       };
     in pkgs-old.spotify)
  ];

  # --- SPICETIFY MODULE ---
  programs.spicetify = {
    enable = true;
  };

  system.stateVersion = "25.11";
}
