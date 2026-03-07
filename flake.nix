{
  description = "My NixOS Configuration";

  inputs = {
    # ✅ NixOS 25.11 Stable Release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, spicetify-nix, ... }: {
    nixosConfigurations = {
      
      WorkStation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/WorkStation
          spicetify-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ruairc = { pkgs, ... }: {
              home.stateVersion = "25.11"; # ✅ Match NixOS version
            };
          }
        ];
      };

      Laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/Laptop
          spicetify-nix.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ruairc = { pkgs, ... }: {
              home.stateVersion = "25.11";
            };
          }
        ];
      };
    };
  };
}