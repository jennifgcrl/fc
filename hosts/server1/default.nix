{
  config,
  pkgs,
  hostName,
  lib,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    ./hardware.nix
  ];

  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  networking.hostName = hostName;

  time.timeZone = "UTC";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "dvorak";
  };

  nixpkgs.config.allowUnfree = true;

  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      tree
      neovim
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    neovim
    tpm2-tss
    sbctl
  ];

  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  services.tailscale.enable = true;
  services.fwupd.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false; # :( card too old
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
