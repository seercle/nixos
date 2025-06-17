{ lib, config, pkgs, ... }:
{
  
  options.pedantix-solver.path = lib.mkOption {
    type = lib.types.str;
  };
  options.pedantix-solver.shellPath = lib.mkOption {
    type = lib.types.str;
  };
  options.pedantix-solver.filePath = lib.mkOption {
    type = lib.types.str;
  };
  options.pedantix-solver.logPath = lib.mkOption {
    type = lib.types.str;
  };
  
  config = {
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
        cd ${config.pedantix-solver.path}
        ${pkgs.nix}/bin/nix-shell -I nixpkgs=${pkgs.path} ${config.pedantix-solver.shellPath} --run "python ${config.pedantix-solver.filePath}" >> ${config.pedantix-solver.logPath} 2>&1
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}

