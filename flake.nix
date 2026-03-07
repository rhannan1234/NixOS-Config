{
  description = "My NixOS Configuration";

  inputs = {
    # 1. Main NixPKGS input (Current Unstable)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. OLD NixPKGS input (For compatible Spotify version 1.2.14)
    # Using the nixos-24.05 branch directly instead of a specific hash
    nixpkgs-old.url = "github:nixos/nixpkgs/nixos-24.05";

    # 3. Home Manager input
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 4. Spicetify Nix input
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-old, home-manager, spicetify-nix, ... }: {
    nixosConfigurations = {
      WorkStation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        # CRITICAL FIX: Explicitly pass nixpkgs-old to all modules
        specialArgs = { inherit nixpkgs-old; };

        modules = [
          ./configuration.nix
          
          # Import Spicetify as a NixOS Module
          spicetify-nix.nixosModules.default
          
          # Import Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            # Configure your user
            home-manager.users.ruairc = { pkgs, ... }: {
              home.stateVersion = "25.11"; 
              home.packages = [ pkgs.git ];
            };
          }
        ];
      };
    };
  };
}
