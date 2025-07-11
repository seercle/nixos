{ lib, config, pkgs, ... }:
{
  options.kafka.publicIp = lib.mkOption {
    type = lib.types.str;
  };
  options.kafka.textPort = lib.mkOption {
    type = lib.types.ints.unsigned;
  };
  options.kafka.controllerPort = lib.mkOption {
    type = lib.types.ints.unsigned;
  };
  config = {
    environment.systemPackages = with pkgs; [ apacheKafka ];
    networking.firewall.allowedTCPPorts = [ config.kafka.textPort ];
    networking.firewall.allowedUDPPorts = [ config.kafka.textPort ];
    services.apache-kafka = {
      enable = true;
      clusterId = "QKRy5pBhSr2vOw3xxDa-sQ";
      formatLogDirs = true;
      settings = {
        listeners = [
          "PLAINTEXT://:${toString config.kafka.textPort}"
          "CONTROLLER://:${toString config.kafka.controllerPort}"
        ];
        "advertised.listeners" = "PLAINTEXT://${config.kafka.publicIp}:${toString config.kafka.textPort}";
        # Adapt depending on your security constraints
        "listener.security.protocol.map" = [
          "PLAINTEXT:PLAINTEXT"
          "CONTROLLER:PLAINTEXT"
        ];
        "controller.quorum.voters" = [
          "1@127.0.0.1:${toString config.kafka.controllerPort}"
        ];
        "controller.listener.names" = ["CONTROLLER"];
        "node.id" = 1;
        "process.roles" = ["broker" "controller"];
        "log.dirs" = ["/var/lib/apache-kafka"];
        "offsets.topic.replication.factor" = 1;
        "transaction.state.log.replication.factor" = 1;
        "transaction.state.log.min.isr" = 1;
      };
    };
    # Set this so that systemd automatically create /var/lib/apache-kafka
    # with the right permissions
    systemd.services.apache-kafka.unitConfig.StateDirectory = "apache-kafka";
  };
}
