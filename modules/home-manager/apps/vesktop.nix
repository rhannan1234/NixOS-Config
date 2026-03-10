# Vesktop/Vencord configuration
{ config, pkgs, lib, ... }:
{
  options.my.apps.vesktop.enable = lib.mkEnableOption "Vesktop/Vencord configuration";

  config.flake.modules = lib.mkIf config.my.apps.vesktop.enable {
    home-manager.users.${config.username} = {
      # Vesktop/Vencord configuration
      home.file.".config/vesktop/vencord/settings.json" = {
        text = builtins.toJSON {
          general = {
            notifyAboutUpdates = true;
            autoUpdate = true;
            useQuickCss = true;
            themeLinks = [];
            enabledThemes = [];
          };

          plugins = {
            FakeNitro = { enabled = true; };
            NoBlockedMessages = { enabled = true; };
            BetterFolders = { enabled = true; };
            BetterSettings = { enabled = true; };
          };

          notifications = {
            timeout = 5000;
            position = "bottom-right";
            useNative = "not-focused";
          };
        };
      };
    };
  };
}
