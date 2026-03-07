{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    
    # Replace discord with vesktop
    # Vesktop includes Vencord by default in nixpkgs
    vesktop

    # Latest official Spotify
    spotify
  ];

  nixpkgs.config.allowUnfree = true;
}