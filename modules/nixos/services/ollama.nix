# Ollama service configuration with ROCm support
{ config, pkgs, lib, ... }:
{
  options.services.ollama-custom = {
    enable = lib.mkEnableOption "Ollama service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ollama-rocm;
      description = "Ollama package to use";
    };
    rocmOverrideGfx = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "ROCm GFX override (e.g., \"12.0.1\")";
    };
    keepAlive = lib.mkOption {
      type = lib.types.str;
      default = "2m";
      description = "Keep alive duration for models";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open firewall ports";
    };
  };

  config.flake.modules = lib.mkIf config.services.ollama-custom.enable {
    nixos.pc = {
      services.ollama = {
        enable = true;
        inherit (config.services.ollama-custom) openFirewall package;
        inherit (config.services.ollama-custom) rocmOverrideGfx;
        environmentVariables = {
          HCC_AMDGPU_TARGET = "gfx1201";
          OLLAMA_KEEP_ALIVE = config.services.ollama-custom.keepAlive;
        };
      };
    };
  };
}
