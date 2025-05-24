{
  config,
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
  ];
}
