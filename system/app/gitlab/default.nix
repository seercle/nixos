{ lib, config, ... }:
{
options.gitlab.httpPort = lib.mkOption {
  type = lib.types.ints.unsigned;
};
options.gitlab.httpsPort = lib.mkOption {
  type = lib.types.ints.unsigned;
};
options.gitlab.sshPort = lib.mkOption {
  type = lib.types.ints.unsigned;
};
options.gitlab.hostname = lib.mkOption {
  type = lib.types.str;
};
options.gitlab.configPath = lib.mkOption {
  type = lib.types.str;
};
options.gitlab.logPath = lib.mkOption {
  type = lib.types.str;
};
options.gitlab.dataPath = lib.mkOption {
  type = lib.types.str;
};
config = {
virtualisation.oci-containers.backend = "docker";
virtualisation.oci-containers.containers."gitlab" = {
image = "gitlab/gitlab-ee:latest";
autoStart = true;
ports = [
"${toString config.gitlab.httpPort}:80"
"${toString config.gitlab.httpsPort}:443"
"${toString config.gitlab.sshPort}:22"
];
volumes = [
"${toString config.gitlab.configPath}:/etc/gitlab"
"${toString config.gitlab.logPath}:/var/log/gitlab"
"${toString config.gitlab.dataPath}:/var/opt/gitlab"
];
log-driver = "journald";
extraOptions = [
"--hostname=${config.gitlab.hostname}"
"--network-alias=gitlab"
"--network=test_default"
"--shm-size=256m"
];
};
};
}
