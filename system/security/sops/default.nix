{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
  ];
  sops = {
    age.generateKey = true;
    age.keyFile = "/root/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
  };
}
