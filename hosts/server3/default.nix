{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./data1-mount.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
    ../../profiles/nixos/graphical.nix
    ../../profiles/home
  ];

  environment.etc.nixos.source = "/home/jennifer/code/fc";
  system.stateVersion = "26.05";
  boot.supportedFilesystems = ["bcachefs"];

  networking.firewall.checkReversePath = "loose";

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.arp_ignore" = 1;
    "net.ipv4.conf.all.arp_announce" = 2;
    "net.ipv4.conf.default.arp_ignore" = 1;
    "net.ipv4.conf.default.arp_announce" = 2;
  };

  environment.sessionVariables = {
    TORCH_CUDA_ARCH_LIST = "8.9";
  };
}
