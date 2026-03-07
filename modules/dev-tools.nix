{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    yazi
    tree
    spicetify-cli
    unzip
  ];
}
