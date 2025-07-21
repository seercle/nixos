{ lib, config, pkgs, ...}:
let
    service = "minio-backup";
    cfg = config.${service};
in {
  options.${service} = with lib; {
    enable = mkEnableOption {
        description = "Enable ${service} for backing up files to MinIO";
    };
    configFile = mkOption {
      type = types.str;
      description = "Path to the file containing the MinIO configuration";
    };
    calendar = mkOption {
      type = types.str;
      description = "Interval between backups";

    };
    bucket = mkOption {
      type = types.str;
      description = "Name of the alias and name of the bucket, separated by a /";
    };
    files = mkOption {
      type = types.str;
      description = "Path to the files to backup, separated by spaces";
    };
    prefix = mkOption {
      type = types.str;
      description = "Prefix for each backup";
    };
    retention = mkOption {
      type = types.ints.unsigned;
      description = "Number of backups to keep in the bucket";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.timers.${service} = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.calendar;
        Persistent = true;
      };
    };
    systemd.services.${service} = with cfg; {
      path = with pkgs; [coreutils gawk zstd gnutar minio-client];

      preStart = ''
        set -e
        cp ${configFile} /root/.mc/config.json
      '';

      script = ''
        set -e
	TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
	ARCHIVE_FILE="/tmp/${prefix}_$TIMESTAMP.tar.zst"
	RETENTION=${toString retention}
	echo "Starting backup process..."
	echo "Creating compressed archive: $ARCHIVE_FILE"
	tar -I 'zstd -T$(nproc) -3' -cf "$ARCHIVE_FILE" ${files}
	echo "Archive created successfully."
	echo "Uploading archive..."
        mc cp "$ARCHIVE_FILE" "${bucket}/"
	echo "Cleaning up local archive..."
        rm "$ARCHIVE_FILE"
        echo "Pruning old backups..."
        BACKUP_LIST=$(mc ls "${bucket}/" | grep "$BACKUP_PREFIX" | awk '{print $6}')
        TOTAL_BACKUPS=$(echo "$BACKUP_LIST" | wc -l)
	if [ $TOTAL_BACKUPS -gt $RETENTION ]; then
            DELETE_COUNT=$((TOTAL_BACKUPS - RETENTION))
            FILES_TO_DELETE=$(echo "$BACKUP_LIST" | head -n $DELETE_COUNT)
            echo "Deleting oldest $DELETE_COUNT backups..."
            for file in $FILES_TO_DELETE; do
                mc rm "${bucket}/$file"
            done
        else
            echo "No old backups to prune."
        fi
        echo "Backup complete."
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };
  };
}
