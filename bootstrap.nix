{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = fill in host name here;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console.keyMap = "dvorak";

  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      git
    ];
  };

  environment.systemPackages = with pkgs; [
    neovim
    tmux
    sbctl
  ];

  system.stateVersion = "25.05";
}
