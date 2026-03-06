{ config, pkgs, ... }: {

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
  ];

  # 3. OpenGL & Vulkan Support (Critical for 32-bit games)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # 4. LACT Service (AMD GPU Control)
  services.lact.enable = true;

  # 5. User Permissions
  # Replace 'ruairc' with your username if different
  users.users.ruairc.extraGroups = [ "video" "render" "input" ];
}
