{ config, lib, pkgs, systemSettings,... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = systemSettings.hostname;
  time.timeZone = systemSettings.timezone;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
}

