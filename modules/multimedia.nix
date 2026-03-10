{ config, pkgs, lib, spicePkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    obsidian
    obs-studio
    
    # Spotify and Spicetify for music customization
    spotify
    spicetify-cli
  ];
  
  # Spicetify for Spotify customization
  programs.spicetify = {
    enable = true;
    
    enabledExtensions = with spicePkgs.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
  };
}
