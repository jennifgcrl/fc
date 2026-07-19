{
  self,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../profiles/darwin
    ../../profiles/home
  ];

  # determinate
  nix.enable = false;
  nix.gc.automatic = lib.mkForce false;

  environment.etc.nix-darwin.source = "/Users/jennifer/code/fc";

  # nix-darwin
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # will be deprecated; currently needed for system.defaults.*
  system.primaryUser = "jennifer";
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # user
  # unfortunately still need to run chsh manually
  users.users.jennifer = {
    home = "/Users/jennifer";
    uid = 501;
  };

  homebrew = {
    masApps = {
    };
    brews = [
      "coder"
      "container"
    ];
    casks = [
      "figma"
      "gcloud-cli"
      "granola"
      "linear"
      "lm-studio"
      "mactex"
      "microsoft-teams"
      "parallels"
      "steam"
      "tor-browser"
    ];
  };
}
