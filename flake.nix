{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Or your specific release, e.g., nixos-23.11
    home-manager = {
      url = "github:nix-community/home-manager";
      # Optional: Ensure HM version matches your NixOS version to prevent breakage
      # inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          # Import the Home Manager NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Configure your user here
            home-manager.users.ruairc = { pkgs, ... }: {
              home.stateVersion = "25.11"; # Set this to your NixOS version
              # Example: Install a package for your user
              home.packages = [ pkgs.git ];
            };
          }
        ];
      };
    };
  };
}
