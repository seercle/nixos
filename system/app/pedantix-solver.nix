{ lib, config, pkgs, ... }:
let
  service = "pedantix-solver";
  cfg = config.${service};
in
{
  options.${service} = with lib; {
    enable = mkEnableOption {
        description = "Enable Pedantix Solver service";
    };
    path = mkOption {
        type = types.str;
    };
    shellPath = mkOption {
        type = types.str;
    };
    filePath = mkOption {
        type = types.str;
    };
    logPath = mkOption {
        type = types.str;
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.timers."pedantix-solver" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        Unit = "pedantix-solver.service";
        OnCalendar = "*-*-* 11:58:00";
        Persistent = true;
      };
    };
    systemd.services."pedantix-solver" = {
      script = ''
        set -eu
        cd ${cfg.path}
        ${pkgs.nix}/bin/nix-shell -I nixpkgs=${pkgs.path} ${cfg.shellPath} --run "python ${cfg.filePath}" >> ${cfg.logPath} 2>&1
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
