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

  environment.sessionVariables = {
    TORCH_CUDA_ARCH_LIST = "8.9";
  };
}
