{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.cudaSupport = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = lib.mkDefault true;
    nvidiaSettings = false;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver.videoDrivers = ["nvidia"];
  services.ollama.package = pkgs.ollama-cuda;
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia

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
