{...}: {
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

  services.ollama.enable = true;
}
