{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    obsidian
    obs-studio
    
    # Spotify and Spicetify for music customization
    spotify
    spicetify-cli
  ];
}
