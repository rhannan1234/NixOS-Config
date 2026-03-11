# Provides an option for declaring NixOS configurations.
# These configurations end up as flake outputs under `#nixosConfigurations."<name>"`.
# A check for the toplevel derivation of each configuration also ends
# under `#checks.<system>."configurations:nixos:<name>"`.
{ lib, config, inputs, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake = {
    nixosConfigurations = lib.mapAttrs' (
      name: { module }: lib.nameValuePair name (lib.nixosSystem {
        inherit (config.systems) system;
        modules = [
          module
          inputs.home-manager.nixosModules.home-manager
          inputs.spicetify-nix.nixosModules.default
          {
            # Allow unfree packages (needed for open-webui, spotify, etc.)
            nixpkgs.config.allowUnfree = true;
            
            # Provide spicePkgs for spicetify configuration
            _module.args.spicePkgs = inputs.spicetify-nix.legacyPackages.${config.systems.system};
            
            # Home Manager configuration
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${config.username}._module.args.spicePkgs = inputs.spicetify-nix.legacyPackages.${config.systems.system};
            };
          }
        ];
      })
    ) config.configurations.nixos;

    checks = lib.mkMerge (lib.mapAttrsToList (
      name: nixos: {
        ${nixos.config.nixpkgs.hostPlatform.system} = {
          "configurations:nixos:${name}" = nixos.config.system.build.toplevel;
        };
      }
    ) config.flake.nixosConfigurations);
  };
}
