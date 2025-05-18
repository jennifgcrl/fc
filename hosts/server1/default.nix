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
  system.stateVersion = "24.11";

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
    open = false; # :( card too old
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
