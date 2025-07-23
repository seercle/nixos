{ pkgs25-05, ... }:
{
  disabledModules = [
    "services/cluster/k3s/default.nix" # Disable the existing k3s module from nixos-24.05
  ];
  imports = [
      "${pkgs25-05.path}/nixos/modules/services/cluster/k3s/default.nix" # Example: Importing k3s module from unstable
    ];
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
  networking.firewall.allowedUDPPorts = [
    # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  ];
  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--debug" # Optionally add additional args to k3s
  ];
  services.k3s.manifests = {
    "local-path-provisioner-hdd".source = ./local-path-provisioner-hdd.yaml;
    "local-path-provisioner-ssd".source = ./local-path-provisioner-ssd.yaml;
    "pvc-nextcloud-app".source = ./pvc-nextcloud-app.yaml;
    "pvc-nextcloud-data".source = ./pvc-nextcloud-data.yaml;
  }
}
