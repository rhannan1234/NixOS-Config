{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    
    # --- Discord with Vencord ---
    (discord.override {
      withVencord = true;
    })

    # --- Latest Official Spotify ---
    # No downgrades, no old imports. Just the standard package.
    spotify
  ];

  # Ensure unfree packages are allowed (Spotify is proprietary)
  nixpkgs.config.allowUnfree = true;
}
