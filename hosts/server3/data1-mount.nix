{pkgs, ...}: {
  # https://wiki.nixos.org/wiki/Bcachefs
  #
  # /data1 is a multi-device bcachefs (5x HDD + 1x NVMe). bcachefs assembles the
  # filesystem by scanning /dev for all members sharing FS_UUID, so we mount by
  # UUID rather than a single device path -- and we wait until every member has
  # been enumerated before mounting, otherwise the mount races udev at boot and
  # comes up degraded (or fails).
  systemd.services."data1-mount" = {
    after = ["local-fs.target"];
    wantedBy = ["multi-user.target"];
    environment = {
      FS_UUID = "a48fd47d-9af6-45b4-a3c6-a5d101bbd9b9";
      EXPECTED_MEMBERS = "6";
      MOUNT_POINT = "/data1";
    };
    script = ''
      #!${pkgs.runtimeShell} -e

      set -x

      ${pkgs.keyutils}/bin/keyctl link @u @s

      # Already mounted? Nothing to do.
      if ${pkgs.util-linux}/bin/mountpoint -q "$MOUNT_POINT"; then
        echo "Drive already mounted at $MOUNT_POINT. Skipping..."
        exit 0
      fi

      # Wait for all bcachefs members to be enumerated. Mounting before every
      # member is present yields a degraded/failed mount, which is the main
      # source of boot-time flakiness. Cap the wait at ~5 min, then attempt the
      # mount anyway so failure is reported cleanly.
      for _ in $(${pkgs.coreutils}/bin/seq 1 60); do
        count=$(${pkgs.util-linux}/bin/lsblk -rno UUID | ${pkgs.gnugrep}/bin/grep -c "^$FS_UUID$" || true)
        if [ "$count" -ge "$EXPECTED_MEMBERS" ]; then
          break
        fi
        echo "Waiting for bcachefs members: $count/$EXPECTED_MEMBERS present..."
        ${pkgs.coreutils}/bin/sleep 5
      done

      # Mount by filesystem UUID so bcachefs assembles all members itself.
      ${pkgs.bcachefs-tools}/bin/bcachefs mount --passphrase-file /data1-key "UUID=$FS_UUID" "$MOUNT_POINT"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
