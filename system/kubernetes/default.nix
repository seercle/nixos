{ pkgs, config, ... }:
let
  secrets = config.sops.secrets;
in {
  #disabledModules = [
  #  "services/cluster/k3s/default.nix" # Disable the existing k3s module from nixos-24.05
  #];
  imports = [
    #"${pkgs25-05.path}/nixos/modules/services/cluster/k3s/default.nix"
    ./blocky
    ./ingress-nginx
    ./longhorn
    ./minio
    ./postgresql
    ./redis
    ./sealed-secrets
  ];
  sops.secrets = {
    K3S_TOKEN = {};
  };
  networking.firewall = {
    allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    ];
    allowedUDPPorts = [
      8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];
  };
  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = secrets.K3S_TOKEN.path;
    extraFlags = toString [
      "--cluster-init"
      "--write-kubeconfig-mode \"0644\""
      "--disable traefik"
      "--disable local-storage"
      "--disable metrics-server"
    ];
  };
}
