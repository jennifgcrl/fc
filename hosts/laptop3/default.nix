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

  environment.etc.nix-darwin.source = "/Users/jennifer/code/fc";

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

  # user
  # unfortunately still need to run chsh manually
  users.users.jennifer = {
    home = "/Users/jennifer";
  };

  home-manager.users.jennifer = {
    programs.zsh = {
      sessionVariables = {
        SSH_AUTH_SOCK = "/Users/jennifer/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
      initContent = lib.mkMerge [
        (
          lib.mkOrder 1001 ''
            path+=~/Library/Application\ Support/JetBrains/Toolbox/scripts
            path+=~/.cache/lm-studio/bin
            path+=/opt/homebrew/bin
          ''
        )
      ];
    };
    home.packages = with pkgs; [
      skimpdf
      rectangle
      monitorcontrol
      mountain-duck
      utm
      # calibre # broken. add to nixos?
    ];
  };

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
      "Flighty" = 1358823008;
      "Hour" = 569089415;
      "Xcode" = 497799835;
    };
    taps = [
      "aws/tap"
    ];
    brews = [
      "mas"
      "syncthing" # move to home.packages?
      "ec2-instance-selector" # contribute to nixpkgs?
    ];
    casks = [
      # make macos usable
      "ghostty"
      "hammerspoon"
      "secretive"
      "steermouse"
      "tailscale" # move to home.packages?
      "zed@preview"

      # tools, nice to have
      "alfred"
      "little-snitch"
      "macfuse"
      "mullvad-vpn" # move to home.packages?

      # apps
      "calibre"
      "chatgpt"
      "claude"
      "cursor"
      "discord"
      "granola"
      "google-chrome"
      "jetbrains-toolbox"
      "ledger-live"
      "lm-studio"
      "notion"
      "notion-calendar"
      "obsidian"
      "proton-mail"
      "signal"
      "slack"
      "standard-notes"
      "steam"
      "stolendata-mpv"
      "ticktick"
      "tor-browser"
      "uhk-agent"
      "witsy"

      # dislike but need :(
      "element"
      "loom"
      "zoom"
    ];

    # manually installed
    # - Epubor Ultimate
  };
}
