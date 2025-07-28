{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    192.168.1.240-192.168.1.250
  ];
  services.k3s.manifests = {
      "metallb".source = ./metallb.yaml;
      "adress-pool".source = ./address-pool.yaml;
  };
}
