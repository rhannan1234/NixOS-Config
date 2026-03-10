# Ollama CLI helper tools
{ config, pkgs, lib, ... }:
{
  options.programs.ollama-tools.enable = lib.mkEnableOption "Ollama CLI helper tools";

  config.flake.modules = lib.mkIf config.programs.ollama-tools.enable {
    nixos.pc = {
      environment.systemPackages = with pkgs; [
        # Unload all models from VRAM
        (writeShellScriptBin "ollama-unload" ''
          #!/usr/bin/env bash
          echo "Unloading all Ollama models from VRAM..."
          curl -s http://localhost:11434/api/generate -d '{"model": ""}' > /dev/null
          if [ $? -eq 0 ]; then
            echo "All models unloaded!"
          else
            echo "Failed. Is Ollama running? (systemctl status ollama)"
            exit 1
          fi
        '')

        # Check loaded models
        (writeShellScriptBin "ollama-status" ''
          #!/usr/bin/env bash
          echo "Currently Loaded Models:"
          curl -s http://localhost:11434/api/ps | ${pkgs.jq}/bin/jq '.models[] | {name, size, expires_at}'
          if [ $? -ne 0 ]; then
            echo "Cannot connect to Ollama"
            exit 1
          fi
        '')
      ];
    };
  };
}
