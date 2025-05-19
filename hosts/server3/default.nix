{...}: {
  imports = [
    ./hardware.nix
    ../../profiles/common
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
  ];

  # nixos
  system.stateVersion = "25.05";

  boot.supportedFilesystems = ["bcachefs"];
}
