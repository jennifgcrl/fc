{
  self,
  pkgs,
  ...
}: {
  # nix
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["jennifer"];
  nix.settings.sandbox = true;
  nixpkgs.config.allowUnfree = true;
  nix.gc.automatic = true;

  # possibly doesn't work over tailscale ssh?
  # nix.distributedBuilds = true;
  # nix.buildMachines = [
  #   {
  #     hostName = "server3";
  #     sshUser = "jennifer";
  #     system = "x86_64-linux";
  #   }
  # ];

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

  # system
  networking.hostName = hostName;

  environment.systemPackages = [];

  # user
  # unfortunately still need to run chsh manually
  users.users.jennifer = {
    home = "/Users/jennifer";
    shell = pkgs.zsh;
  };
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  # macos
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;
  homebrew = {
    enable = true;
    user = "jennifer";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Blurred" = 1497527363;
      "Hour" = 569089415;
      "Perplexity" = 6714467650;
      "Xcode" = 497799835;
    };
    taps = [
      "aws/tap"
    ];
    brews = [
      "mas"
      "syncthing"
      "ec2-instance-selector"
    ];
    casks = [
      "alfred"
      "calibre"
      "chatgpt"
      "claude"
      "cryptomator"
      "cursor"
      "discord"
      "element"
      "figma"
      "ghostty"
      "granola"
      "hammerspoon"
      "jetbrains-toolbox"
      "ledger-live"
      "little-snitch"
      "lm-studio"
      "loom"
      "macfuse"
      "messenger"
      "monitorcontrol"
      "mountain-duck"
      "mullvadvpn"
      "notion"
      "notion-calendar"
      "notion-mail"
      "obsidian"
      "podman-desktop"
      "proton-mail"
      "rapidapi"
      "rectangle"
      "secretive"
      "signal"
      "skim"
      "slack"
      "standard-notes"
      "steam"
      "steermouse"
      "stolendata-mpv"
      "sublime-merge"
      "tailscale"
      "ticktick"
      "tor-browser"
      "utm"
      "veracrypt"
      "visual-studio-code"
      "vlc"
      "zed@preview"
      "zen"
      "zoom"
    ];
  };
}
