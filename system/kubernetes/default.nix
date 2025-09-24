{ pkgs, ... }:
{
  imports = [
    ./blocky
    ./fluxcd
    ./ingress-nginx
    ./longhorn
    ./minio
    ./postgresql
    ./redis
    ./sealed-secrets
  ];
  environment.systemPackages = with pkgs; [
    kubernetes
  ];
  networking.firewall = {
    allowedTCPPorts = [
      6443
      2379
      2380
    ];
    allowedUDPPorts = [
      8472
    ];
  };
}
