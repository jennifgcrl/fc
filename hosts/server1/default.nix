{
  pkgs,
  hostName,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  imports = [
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  };

  environment.systemPackages = with pkgs; [
    neovim
    tpm2-tss
    sbctl
  ];

  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  services.tailscale.enable = true;

  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "24.11";
}
