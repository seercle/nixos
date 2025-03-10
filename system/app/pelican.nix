{ pkgs, ... }:
{
  users.groups.www-data = {};
  users.users.www-data = {
    isNormalUser = false;
    isSystemUser = true;
    group = "www-data";
  };
  environment.systemPackages = with pkgs; [
    php
    php83Packages.composer
    cron
  ];
}
