{ config, pkgs, ... }: {
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
    source = ../../scripts/rebuildall;
    executable = true;
  };

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
}
