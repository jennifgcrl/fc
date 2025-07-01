{
  lib,
  pkgs,
  config,
  ...
}: rec {
  nixpkgs.config.cudaSupport = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = lib.mkDefault true;
    nvidiaSettings = false;
    # package = config.boot.kernelPackages.nvidiaPackages.latest;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.nvidia-container-toolkit.enable = true;

  programs.nix-ld = {
    libraries = [
      hardware.nvidia.package
    ];
  };

  # unfortunately broken at the moment. needs debugging.
  # virtualisation.containerd.settings = {
  #   plugins."io.containerd.grpc.v1.cri" = {
  #     enable_cdi = true;
  #     cdi_spec_dirs = ["/var/run/cdi"];
  #     containerd = {
  #       default_runtime_name = "nvidia";

  #       runtimes.nvidia = {
  #         privileged_without_host_devices = false;
  #         runtime_engine = "";
  #         runtime_root = "";
  #         runtime_type = "io.containerd.runc.v2";
  #         options = {
  #           BinaryName = "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime";
  #         };
  #       };
  #     };
  #   };
  # };

  hardware.graphics = {
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  services.lact.enable = true;

  services.ollama.package = pkgs.ollama-cuda;
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia

    nvidia-container-toolkit

    # list may not be complete
    cudaPackages.cuda_cuobjdump
    cudaPackages.cuda_gdb
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_nvdisasm
    cudaPackages.cuda_nvprune
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cupti
    cudaPackages.cuda_cuxxfilt
    cudaPackages.cuda_nvml_dev
    cudaPackages.cuda_nvrtc
    cudaPackages.cuda_nvtx
    cudaPackages.cuda_profiler_api
    cudaPackages.cuda_sanitizer_api
    cudaPackages.libcublas
    cudaPackages.libcufft
    cudaPackages.libcurand
    cudaPackages.libcusolver
    cudaPackages.libcusparse
    cudaPackages.libnpp
    cudaPackages.nccl
  ];
}
