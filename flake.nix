# Dendritic pattern with flake-parts
# Every Nix file (other than this) is a flake-parts module
{
  description = "My NixOS Configuration";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

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
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake
      { inherit inputs; }
      {
        systems = [ "x86_64-linux" ];
        
        imports = [ (inputs.import-tree ./modules) ./hosts ];
        
        config.configurations.nixos = lib.mkMerge [
          (lib.mapAttrs' (name: { module }: lib.nameValuePair name {
            module = module;
          }) config.hosts.nixos)
        ];
      };
}
