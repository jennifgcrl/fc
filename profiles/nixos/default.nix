{
  pkgs,
  home-manager,
  lib,
  ...
}: {
  imports = [
    ../common
    home-manager.nixosModules.home-manager
  ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";
  hardware.enableAllFirmware = true;

  environment.systemPackages = with pkgs; [
    neovim
    ghostty.terminfo
    pciutils
  ];

  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    # for tailscale
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "524288";
    }
    {
      domain = "*";
      type = "hard";
      item = "nofile";
      value = "524288";
    }
  ];

  services.fwupd.enable = true;
  services.fstrim.enable = true;
  services.tailscale.enable = true;
  services.eternal-terminal.enable = true;
  services.ollama.enable = true;
  programs.nix-ld.enable = true;
  virtualisation.podman.enable = true;

  # TODO: set up rx-udp-gro-forwarding on rx-gro-list off
  # see: https://tailscale.com/kb/1320/performance-best-practices#ethtool-configuration

  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = ["wheel"];

    # for podman
    subUidRanges = [
      {
        startUid = 100000;
        count = 65536;
      }
    ];
    subGidRanges = [
      {
        startGid = 100000;
        count = 65536;
      }
    ];
  };
}
