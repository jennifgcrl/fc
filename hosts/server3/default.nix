{...}: {
  imports = [
    ./hardware.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
    ../../profiles/home
    ../../profiles/graphical
  ];

  # nixos
  system.stateVersion = "25.05";

  boot.supportedFilesystems = ["bcachefs"];
}
