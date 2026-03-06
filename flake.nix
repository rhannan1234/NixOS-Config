{
  description = "My NixOS Configuration";

  inputs = {
    # 1. Main NixPKGS input
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # 2. Home Manager input (Top Level)
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures HM matches your OS version
    };

    # 3. Spicetify Nix input (Top Level - FIXED)
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures Spicetify matches your OS version
    };
  };

  outputs = { nixpkgs, home-manager, spicetify-nix, ... }: {
    nixosConfigurations = {
      WorkStation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          
          # Import Spicetify as a NixOS Module (Correct placement)
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
