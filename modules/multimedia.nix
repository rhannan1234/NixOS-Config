{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    brave
    obsidian
    obs-studio
  ];

  # Spicetify for Spotify customization
  programs.spicetify = {
    enable = true;
    theme = "catppuccin-mocha";
    colorScheme = "mocha";
    
    enabledExtensions = with config.programs.spicetify.extensions; [
      adblock
      hidePodcasts
      shuffle
    ];
  };
}