{ config, lib, pkgs, hostname, nixpkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    home-manager
  ];
  nixpkgs.config.allowUnfree = true;
}
