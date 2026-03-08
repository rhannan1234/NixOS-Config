{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vesktop
    spotify
    brave
    obsidian
  ];

  nixpkgs.config.allowUnfree = true;
}