{ config, lib, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}

