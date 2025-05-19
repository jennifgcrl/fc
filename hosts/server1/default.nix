{...}: {
  imports = [
    ./hardware.nix
    ../../profiles/common
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
  ];

  # nixos
  system.stateVersion = "24.11";

  hardware.nvidia.open = false; # :( card too old
}
