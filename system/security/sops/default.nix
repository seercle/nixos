{ pkgs, sops, ... }:
{
  environment.systemPackages = with pkgs; [
    sops
  ];
  sops = {
    age.keyFile = "/root/.config/sops/age/keys.txt";
  };
}
