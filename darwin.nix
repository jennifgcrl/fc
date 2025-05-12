{
  self,
  pkgs,
  ...
}: {
  environment.systemPackages = [];

  environment.shells = [pkgs.zsh];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.settings.trusted-users = ["jennifer"];

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

  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # unfortunately still need to chsh to set this
  users.users.jennifer = {
    home = "/Users/jennifer";
    shell = pkgs.zsh;
  };

  # will be deprecated; currently needed for services.jankyborders
  system.primaryUser = "jennifer";

  services.jankyborders.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

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
      "font-dm-sans"
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
