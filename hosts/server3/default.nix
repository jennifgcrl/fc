{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
    ../../profiles/nixos/graphical.nix
    ../../profiles/home
  ];

  environment.etc.nixos.source = "/home/jennifer/code/fc";
  system.stateVersion = "25.05";
  boot.supportedFilesystems = ["bcachefs"];

  # https://wiki.nixos.org/wiki/Bcachefs
  systemd.services."data1-mount" = {
    after = ["local-fs.target"];
    wantedBy = ["multi-user.target"];
    environment = {
      DEVICE_PATH = "/dev/disk/by-partuuid/1c0f4731-64fc-4468-b207-af87cf9f2ba9";
      MOUNT_POINT = "/data1";
    };
    script = ''
      #!${pkgs.runtimeShell} -e

      ${pkgs.keyutils}/bin/keyctl link @u @s

      # Check if the device path exists
      if [ ! -b "$DEVICE_PATH" ]; then
        echo "Error: Device path $DEVICE_PATH does not exist."
        exit 1
      fi

      # Check if the drive is already mounted
      if ${pkgs.util-linux}/bin/mountpoint -q "$MOUNT_POINT"; then
        echo "Drive already mounted at $MOUNT_POINT. Skipping..."
        exit 0
      fi

      # Wait for the device to become available
      while [ ! -b "$DEVICE_PATH" ]; do
        echo "Waiting for $DEVICE_PATH to become available..."
        sleep 5
      done

      # Mount the device
      ${pkgs.bcachefs-tools}/bin/bcachefs mount -f /data1-key "$DEVICE_PATH" "$MOUNT_POINT"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };

  services.ollama.enable = true;

  users.users.jennifer = {
    shell = pkgs.nushell;
  };
}
