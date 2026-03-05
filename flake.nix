{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Optional: For secrets management
    # sops-nix.url = "github:mic92/sops-nix";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      workstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/workstation/configuration.nix
          # inputs.sops-nix.nixosModules.sops # Uncomment if using sops
        ];
        specialArgs = { inherit inputs; };
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
          # inputs.sops-nix.nixosModules.sops
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
