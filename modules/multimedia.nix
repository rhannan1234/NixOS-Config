{ config, pkgs, ... }: {  # <--- Ensure nixpkgs-old is NOT here
  environment.systemPackages = with pkgs; [
    
    (discord.override {
      withVencord = true;
    })

    # Latest official Spotify
    spotify
  ];

  nixpkgs.config.allowUnfree = true;
}
