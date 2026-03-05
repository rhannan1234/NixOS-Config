{ pkgs, ... }: {
  home.username = "youruser";
  home.homeDirectory = "/home/youruser";
  home.stateVersion = "23.11"; # Set this to your current NixOS version

  # Example: Install home packages
  home.packages = with pkgs; [
    firefox
    git
  ];

  # Example: Manage a dotfile
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "you@example.com";
  };

  programs.home-manager.enable = true;
}
