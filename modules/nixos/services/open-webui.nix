# Open WebUI service configuration
{ config, pkgs, lib, ... }:
{
  options.services.open-webui-custom = {
    enable = lib.mkEnableOption "Open WebUI service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to run Open WebUI on";
    };
    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host to bind Open WebUI to";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open firewall ports";
    };
    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "2m";
      description = "OLLAMA_KEEP_ALIVE environment variable";
    };
  };

  config.flake.modules = lib.mkIf config.services.open-webui-custom.enable {
    nixos.pc = {
      services.open-webui = {
        enable = true;
        inherit (config.services.open-webui-custom) port host openFirewall;
        environment = {
          OLLAMA_KEEP_ALIVE = config.services.open-webui-custom.keepAlive;
        };
      };
    };
  };
}
