# Provides an option for declaring Home Manager configurations.
# These configurations end up as flake outputs under `#homeConfigurations."<name>"`.
{ lib, config, inputs, ... }:
{
  options.configurations.home-manager = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake = {
    homeConfigurations = lib.flip lib.mapAttrs config.configurations.home-manager (
      name: { module }: inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          module
          {
            home.stateVersion = "25.11";
          }
        ];
        pkgs = import inputs.nixpkgs {
          system = config.systems.system;
        };
      }
    );
  };
}
