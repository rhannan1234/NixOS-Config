# Home Manager root module - imports all HM submodules
{ config, pkgs, lib, ... }:
{
  # Import all Home Manager submodules
  imports = [
    ./home-manager/shells
    ./home-manager/programs
    ./home-manager/apps
  ];
  
  # Enable all HM modules by default
  my.shells.enable = true;
  my.hm-programs.enable = true;
  my.apps.vesktop.enable = true;
}
