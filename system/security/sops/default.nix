{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
  ];
  sops = {
    age.generateKey = true;
    age.keyFile = "/root/.config/sops/age/nixos.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
