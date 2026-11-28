{
  pkgs,
  home-manager,
  lib,
  ...
}:
{
  imports = [
    ../common
    home-manager.nixosModules.home-manager
  ];

  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";
  hardware.enableAllFirmware = true;

  nix.gc.options = "--delete-older-than 14d";
  nix.optimise.automatic = true;
  nix.channel.enable = false;

  environment.systemPackages = with pkgs; [
    neovim
    ghostty.terminfo
    pciutils
    sshfs
  ];

  # default is \infty??? insanity
  boot.loader.systemd-boot.configurationLimit = 8;

  #boot.kernelPackages = lib.mkOverride 1001 pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages;

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
  services.tailscale.extraSetFlags = [
    "--ssh"
    "--advertise-exit-node"
  ];
  services.tailscale.useRoutingFeatures = "both";
  systemd.services.tailscale-udp-gro = {
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    path = with pkgs; [
      ethtool
      iproute2
      gawk
      coreutils
    ];
    serviceConfig.Type = "oneshot";
    script = ''
      devs=$({
        ip -4 -o route get 8.8.8.8 || true
        ip -6 -o route get 2001:4860:4860::8888 || true
      } 2>/dev/null | awk '{for (i = 1; i < NF; i++) if ($i == "dev") print $(i + 1)}' | sort -u)
      for dev in $devs; do
        ethtool -K "$dev" rx-udp-gro-forwarding on rx-gro-list off || echo "could not set UDP GRO forwarding on $dev"
      done
    '';
  };
  services.eternal-terminal.enable = true;
  virtualisation.podman.enable = true;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  users.users.jennifer = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

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
