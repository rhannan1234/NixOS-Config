{ config, pkgs, ... }: {
  home.stateVersion = "25.11";

  # --- CORRECTED PATH FOR VESKTOP ---
  # The path MUST be .config/vesktop/vencord/settings.json
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
        # FakeProfileThemes = { enabled = true; };
        NoBlockedMessages = { enabled = true; };
        # YoutubeAdblock = { enabled = true; };
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