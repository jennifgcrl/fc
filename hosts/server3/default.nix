{...}: {
  imports = [
    ./hardware.nix
    ./data1-mount.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
    ../../profiles/nixos/graphical.nix
    ../../profiles/nixos/k8s.nix
    ../../profiles/home
  ];

  environment.etc.nixos.source = "/home/jennifer/code/fc";
  system.stateVersion = "25.05";
  boot.supportedFilesystems = ["bcachefs"];

  services.ollama.enable = true;

  services.kubernetes.roles = ["master"];
}
