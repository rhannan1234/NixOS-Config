{ pkgs, ... }: {
  # Shared NixOS settings
  time.timeZone = "UTC"; 
  i18n.defaultLocale = "en_US.UTF-8";

  # Example: Enable a common user (change 'youruser')
  users.users.youruser = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    packages = with pkgs; [ git vim ];
  };

  # Enable common services
  services.openssh.enable = true;
  networking.networkmanager.enable = true;
}
