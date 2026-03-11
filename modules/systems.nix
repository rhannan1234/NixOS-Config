# Systems configuration module for flake-parts
{ lib, config, ... }: {
  options.systems = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "x86_64-linux" ];
    description = "List of systems to build for";
  };

  config.systems = [ "x86_64-linux" ];
}
