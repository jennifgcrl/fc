{ config, ... }:
let
  gpu-unlock = config.boot.kernelPackages.gpu-unlock;
in
{
  boot.extraModulePackages = [ gpu-unlock ];
  hardware.firmware = [ gpu-unlock.firmware ];
  boot.kernelParams = [ "gpu_unlock.targets=all" ];

  # gpu_unlock must finish before nvidia binds a card. kmod honours only the
  # first "softdep nvidia" line it reads, in filename order, and the driver
  # ships its own in modules.softdep. This file sorts ahead of that and of
  # nixos.conf, so it restates their entries. If the unlock silently stops,
  # check `journalctl -k -b --grep=gpu_unlock` and
  # `modprobe --show-depends nvidia`.
  environment.etc."modprobe.d/00-gpu-unlock.conf".text = ''
    softdep nvidia pre: ecdh_generic ecdsa_generic gpu_unlock post: nvidia-uvm
  '';
}
