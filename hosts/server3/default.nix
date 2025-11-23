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
    ../../profiles/nixos/k8s.nix
    ../../profiles/home
  ];

  environment.etc.nixos.source = "/home/jennifer/code/fc";
  system.stateVersion = "25.05";
  boot.supportedFilesystems = ["bcachefs"];

  services.ollama.enable = true;

  services.kubernetes.roles = ["master"];

  environment.sessionVariables = {
    TORCH_CUDA_ARCH_LIST = "8.9";
  };

  services.printing.enable = true;

  # Bridge configuration for ethernet devices
  networking.bridges = {
    br0 = {
      interfaces = ["eno1" "enp70s0"];
    };
  };

  networking.interfaces.br0.useDHCP = true;
  networking.interfaces.eno1.useDHCP = false;
  networking.interfaces.enp70s0.useDHCP = false;

  # Force DHCP only on bridge interface
  networking.dhcpcd.enable = true;
  networking.dhcpcd.allowInterfaces = ["br0"];
  networking.dhcpcd.denyInterfaces = ["eno1" "enp70s0"];

  services.hardware.openrgb.enable = true;
  environment.systemPackages = with pkgs; [openrgb-with-all-plugins];
}
