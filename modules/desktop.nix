{ config, pkgs, ... }: {
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  # ✅ FIX: Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;

  # ✅ FIX: Also enable SSH keyring component (helps with gkr-pam)
  services.gnome.gnome-keyring.components = [ "pkcs11" "secrets" "ssh" ];
}