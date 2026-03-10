{
  description = "My NixOS Configuration";

  inputs = {
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

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      ...
    }:
    let
      # Shared Home Manager configuration
      homeManagerConfig = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.ruairc = import ./home.nix;
      };

      # Helper function to create NixOS configurations
      mkNixosConfig = { hostname, system, extraModules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules =
            [
              ./hosts/${hostname}
              spicetify-nix.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                # Allow unfree packages (needed for open-webui, spotify, etc.)
                nixpkgs.config.allowUnfree = true;
                
                home-manager = homeManagerConfig;
              }
            ]
            ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        WorkStation = mkNixosConfig {
          hostname = "WorkStation";
          system = "x86_64-linux";
        };

        Laptop = mkNixosConfig {
          hostname = "Laptop";
          system = "x86_64-linux";
        };
      };
    };
}
