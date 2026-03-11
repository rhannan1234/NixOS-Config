# Shell configuration (bash and zsh)
{ config, pkgs, lib, ... }:
{
  options.my.shells = {
    enable = lib.mkEnableOption "Shell configuration";
    bash.enable = lib.mkEnableOption "Bash configuration" // { default = true; };
    zsh.enable = lib.mkEnableOption "Zsh configuration";
  };

  config.flake.modules = lib.mkIf config.my.shells.enable {
    home-manager.users.${config.username} = lib.mkMerge [
      (lib.mkIf config.my.shells.bash.enable {
        programs.bash = {
          enable = true;
          shellAliases = {
            ll = "ls -la";
            ".." = "cd ..";
            "..." = "cd ../..";
            update = "sudo nixos-rebuild switch --flake .";
            upgrade = "sudo nixos-rebuild switch --upgrade --flake .";
          };
          initExtra = ''
            # Custom bash settings
            export EDITOR=nano
          '';
        };
      })

      (lib.mkIf config.my.shells.zsh.enable {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = {
            ll = "ls -la";
            ".." = "cd ..";
            "..." = "cd ../..";
            update = "sudo nixos-rebuild switch --flake .";
            upgrade = "sudo nixos-rebuild switch --upgrade --flake .";
          };
          initExtra = ''
            # Custom zsh settings
            export EDITOR=nano
          '';
        };
      })
    ];
  };
}
