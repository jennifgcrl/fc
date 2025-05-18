{
  config,
  pkgs,
  lib,
  hostName,
  ...
}: {
  # nix
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["jennifer"];
  nix.settings.sandbox = true;
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;  # see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion

  # user
  users.users.jennifer = {
    shell = pkgs.zsh;
  };
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  networking.hostName = hostName;
}
