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

  # 3. OpenGL & Vulkan Support
  # Note: driSupport and driSupport32Bit are now automatic when enable=true
  hardware.opengl = {
    enable = true;
  };

  # 4. LACT Service (AMD GPU Control)
  services.lact.enable = true;

  # 5. User Permissions
  users.users.ruairc.extraGroups = [ "video" "render" "input" ];
}
