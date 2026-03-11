# Gaming configuration (Steam, AMD GPU tools)
{ config, pkgs, lib, ... }:
{
  flake.modules = {
    nixos.pc = {
      # Enable Steam
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      # Gaming packages
      environment.systemPackages = with pkgs; [
        steam
        heroic
        mangohud
        goverlay
        lact
        vulkan-tools
        protonplus
      ];

      # LACT Service for AMD GPU control
      services.lact.enable = true;

      # Add input group for gaming peripherals
      users.users.${config.username}.extraGroups = [ "input" ];
    };
  };
}
