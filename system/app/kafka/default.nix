{ lib, config, pkgs, ... }:
let
  service = "kafka";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
      description = "Enable Apache Kafka service";
    };
    publicIp = mkOption {
      type = types.str;
      description = "Public IP address of the Kafka broker";
    };
    textPort = mkOption {
      type = types.ints.unsigned;
      default = 9092;
      description = "Port for plaintext communication with Kafka";
    };
    controllerPort = mkOption {
      type = types.ints.unsigned;
      default = 9093;
      description = "Port for controller communication in Kafka";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ apacheKafka ];
    networking.firewall.allowedTCPPorts = [ cfg.textPort ];
    networking.firewall.allowedUDPPorts = [ cfg.textPort ];
    services.apache-kafka = {
      enable = true;
      clusterId = "QKRy5pBhSr2vOw3xxDa-sQ";
      formatLogDirs = true;
      settings = {
        listeners = [
          "PLAINTEXT://:${toString cfg.textPort}"
          "CONTROLLER://:${toString cfg.controllerPort}"
        ];
        "advertised.listeners" = "PLAINTEXT://${cfg.publicIp}:${toString cfg.textPort}";
        # Adapt depending on your security constraints
        "listener.security.protocol.map" = [
          "PLAINTEXT:PLAINTEXT"
          "CONTROLLER:PLAINTEXT"
        ];
        "controller.quorum.voters" = [
          "1@127.0.0.1:${toString cfg.controllerPort}"
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
