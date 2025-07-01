{
  pkgs,
  hostName,
  ...
}:
{
  # nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "jennifer" ];
  nix.settings.sandbox = true;
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;

  # system
  networking.hostName = hostName;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # user
  users.users.jennifer = {
    shell = pkgs.nushell;
  };
  environment.shells = [
    pkgs.zsh
    pkgs.nushell
  ];
  programs.zsh.enable = true;
}
