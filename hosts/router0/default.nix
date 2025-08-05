{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../profiles/nixos
    ../../profiles/nixos/secureboot.nix
    ../../profiles/home
  ];

  environment.etc.nixos.source = "/home/jennifer/code/fc";
  system.stateVersion = "25.05";

  services.printing.enable = true;

  # Bridge configuration for ethernet devices
  networking.bridges = {
    br0 = {
      interfaces = ["enp1s0" "enp2s0" "enp4s0" "enp5s0" "enp6s0" "enp7s0"];
    };
  };

  networking.interfaces.br0.useDHCP = true;
  networking.interfaces.enp1s0.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = false;
  networking.interfaces.enp6s0.useDHCP = false;
  networking.interfaces.enp7s0.useDHCP = false;

  networking.dhcpcd.enable = true;
  networking.dhcpcd.allowInterfaces = ["br0"];
  networking.dhcpcd.denyInterfaces = ["enp1s0" "enp2s0" "enp4s0" "enp5s0" "enp6s0" "enp7s0"];
}
