{
  lib,
  pkgs,
  lanzaboote,
  ...
}: {
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];
  boot.loader.efi.canTouchEfiVariables = true; # not sure if needed
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # generate with sbctl create-keys
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss
    sbctl
  ];
}
