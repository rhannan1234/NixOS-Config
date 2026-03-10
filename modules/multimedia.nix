{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    obsidian
    obs-studio
    spotify
  ];
  
  # Spicetify for Spotify customization
  programs.spicetify = {
    enable = true;
    
    # Theme configuration - using built-in catppuccin theme
    theme = {
      name = "catppuccin-mocha";
      package = pkgs.spicetify-themes;
    };
    
    colorScheme = "mocha";
    
    enabledExtensions = with config.programs.spicetify.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
  };
}
