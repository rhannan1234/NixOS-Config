# Multimedia configuration (Spotify, Discord, etc.)
{ config, pkgs, lib, ... }:
{
  flake.modules = {
    nixos.pc = {
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
        
        enabledExtensions = with config._module.args.spicePkgs.extensions; [
          adblock
          hidePodcasts
          shuffle
        ];
      };
    };
  };
}
