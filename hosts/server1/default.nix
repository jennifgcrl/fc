{...}: {
  imports = [
    ./hardware.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/nixos/nvidia.nix
    ../../profiles/home
  ];

  # nixos
  system.stateVersion = "24.11";

  hardware.nvidia.open = false; # :( card too old
}
