# Host configurations module
{ lib, config, ... }: {
  options.hosts.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.hosts.nixos = {
    WorkStation = {
      module = ./WorkStation;
    };
    # Laptop = {
    #   module = ./Laptop;
    # };
  };
}
