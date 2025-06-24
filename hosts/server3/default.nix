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

  # Use tinygrad fork for P2P support
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs (oldAttrs: {
  #  postUnpack = ''
  #    ${oldAttrs.postUnpack or ""}
  #    rm -rf $sourceRoot/kernel-open
  #    cp -r ${pkgs.fetchFromGitHub {
  #      owner = "tinygrad";
  #      repo = "open-gpu-kernel-modules";
  #      rev = "a17dd14d8bf4a446e15d50f8894c85075881a82c";
  #      hash = "sha256-Gy5TWbpYMgU2cMjCTorh2F1I7UqAUCQIJZ4NnEkRrT4=";
  #    }}/kernel-open $sourceRoot/
  #    chmod -R u+w $sourceRoot/kernel-open
  #  '';
  #});
}
