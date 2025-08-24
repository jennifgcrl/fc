{
  pkgs,
  home-manager,
  lib,
  nix-alien,
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
    sshfs
    nix-alien.packages.${system}.nix-alien
  ];

  boot.kernelPackages = lib.mkOverride 1001 pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    # for tailscale
    "net.ipv4.ip_forward" = lib.mkForce 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # TODO: review these
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
  virtualisation.podman.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.extraGroups.docker.members = ["jennifer"];
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

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

  # virt
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["jennifer"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = [
    ];
  };

  services.syncthing = {
    enable = true;
    group = "users";
    user = "jennifer";
    dataDir = "/home/jennifer/Sync";
    configDir = "/home/jennifer/.local/state/syncthing";
  };
}
