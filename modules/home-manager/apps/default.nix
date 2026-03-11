# Home Manager apps root module - imports all app submodules
{ config, pkgs, lib, ... }:
{
  # Import all app submodules
  imports = [
    ./vesktop.nix
  ];
}
