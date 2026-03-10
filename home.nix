{ config, pkgs, ... }: {
  home.stateVersion = "25.11";

  # ✅ Explicitly add to PATH via shell profile (more reliable than sessionPath)
  programs.bash.profileExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';
  # If you use zsh instead:
  programs.zsh.profileExtra = ''
    export PATH="$HOME/.local/bin:$PATH"
  '';

  home.file.".local/bin/rebuildall" = {
    source = ./scripts/rebuildall;
    executable = true;
  };

  # --- Vesktop config ---
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
}