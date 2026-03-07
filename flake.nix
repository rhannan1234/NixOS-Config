{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # REMOVED: nixpkgs-old input

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, spicetify-nix, ... }: { # Removed nixpkgs-old from args
    nixosConfigurations = {
      
      WorkStation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # REMOVED: specialArgs = { inherit nixpkgs-old; };
        modules = [
          ./hosts/WorkStation
          spicetify-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ruairc = { pkgs, ... }: {
              home.stateVersion = "25.11";
              home.packages = [ pkgs.git ];
            };
          }
        ];
      };

      Laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # REMOVED: specialArgs = { inherit nixpkgs-old; };
        modules = [
          ./hosts/Laptop
          spicetify-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
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
