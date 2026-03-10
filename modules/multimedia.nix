{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    spotify
    brave
    obsidian
    obs-studio
  ];
}