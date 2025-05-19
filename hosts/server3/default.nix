{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../profiles/common
    ../../profiles/nixos
  ];

  # nixos
  system.stateVersion = "25.05";

  boot.supportedFilesystems = [ "bcachefs" ];
  boot.loader.efi.canTouchEfiVariables = true; # not sure if needed
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # generate with sbctl create-keys
  };
  services.fwupd.enable = true;

  environment.systemPackages = with pkgs; [
    tpm2-tss
    sbctl
  ];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
