{
  lib,
  pkgs,
  config,
  ...
}: {
  nixpkgs.config.cudaSupport = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = lib.mkDefault true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.nvidia-container-toolkit.enable = true;

  # ctk - Regular Docker
  virtualisation.docker.daemon.settings.features.cdi = true;
  # ctk - Rootless Docker
  virtualisation.docker.rootless.daemon.settings.features.cdi = true;
  # (podman doesn't need any configs)

  hardware.graphics = {
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

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
  ];
}
