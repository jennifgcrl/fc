{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = lib.mkDefault true;
    nvidiaSettings = false;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.xserver.videoDrivers = ["nvidia"];
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia
  ];
}
