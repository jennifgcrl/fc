{
  config,
  pkgs,
  hostName,
  lib,
  ...
}: {
  # nix
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # hardware
  imports = [
    ./hardware.nix
  ];
  services.fwupd.enable = true;

  # system
  networking.hostName = hostName;

  boot.loader.efi.canTouchEfiVariables = true; # not sure if needed
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # generate with sbctl create-keys
  };
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
  };

  environment.systemPackages = with pkgs; [
    neovim
    tpm2-tss
    sbctl
    ghostty.terminfo
  ];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # :( card too old
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # user
  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  services.tailscale.enable = true;
  services.eternal-terminal.enable = true;

  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
