# Home Manager programs configuration (PATH, scripts)
{ config, pkgs, lib, ... }:
{
  options.my.hm-programs.enable = lib.mkEnableOption "Home Manager programs";

  config.flake.modules = lib.mkIf config.my.hm-programs.enable {
    home-manager.users.${config.username} = {
      home.stateVersion = "25.11";

      # Add ~/.local/bin to PATH via shell profile
      programs.bash.profileExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      programs.zsh.profileExtra = ''
        export PATH="$HOME/.local/bin:$PATH"
      '';

      # Install rebuildall script
      home.file.".local/bin/rebuildall" = {
        source = ../scripts/rebuildall;
        executable = true;
      };
    };
  };
}
