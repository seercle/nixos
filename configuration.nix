{ config, lib, pkgs,... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}

