{ config, pkgs, lib, ... }: {

  # 1. Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # 2. Install Gaming Packages
  environment.systemPackages = with pkgs; [
    steam
    heroic
    mangohud
    goverlay
    lact
    protonup-qt
    vulkan-tools
    lsfg-vk
    protonplus
  ];

  # 3. OpenGL & Vulkan Support
  hardware.graphics = {
    enable = true;
    enable32Bit = lib.mkForce true;
  };

  # 4. LACT Service (AMD GPU Control)
  services.lact.enable = true;

  # 5. User Permissions
  users.users.ruairc.extraGroups = [ 
    "input"
  ];
}