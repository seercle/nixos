{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    kubernetes
    fluxcd
    nfs-utils #Longhorn
  ];
  networking.firewall = {
    allowedTCPPorts = [
      # Kubernetes
      6443
      2379
      2380
      # DNS
      853
      53
      # HTTP
      80
      443
      # Git
      22
    ];
    allowedUDPPorts = [
      # Kubernetes
      8472
      # DNS
      53
      # HTTP
      80
      443
    ];
  };

  # Longhorn
  systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];
  virtualisation.docker.logDriver = "json-file";
  services.openiscsi = {
    enable = true;
    name = "${config.networking.hostName}-initiatorhost";
  };
  systemd.services.iscsid.serviceConfig = {
    PrivateMounts = "yes";
    BindPaths = "/run/current-system/sw/bin:/bin";
  };
}
