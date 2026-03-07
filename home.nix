# home.nix
{ config, pkgs, ... }: {
  home.stateVersion = "25.11";

  # Optional: You can also move 'spotify' or other user-specific packages here
  # home.packages = with pkgs; [ spotify ]; 

  # --- Vencord Configuration ---
  home.file.".config/Vencord/settings.json" = {
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
        FakeProfileThemes = { enabled = true; };
        NoBlockedMessages = { enabled = true; };
        YoutubeAdblock = { enabled = true; };
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
}
