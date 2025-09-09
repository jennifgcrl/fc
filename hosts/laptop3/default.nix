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
    programs.nushell = {
      environmentVariables = {
        SSH_AUTH_SOCK = "/Users/jennifer/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
      extraConfig = lib.mkOrder 501 ''
        path add ~/Library/Application\ Support/JetBrains/Toolbox/scripts
        path add ~/.cache/lm-studio/bin
        path add /opt/homebrew/bin
        path add /Library/TeX/texbin
      '';
    };
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
      "Flighty" = 1358823008;
      "Hour" = 569089415;
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Synctrain" = 6553985316;
      "Xcode" = 497799835;
    };
    taps = [
      "aws/tap"
    ];
    brews = [
      "mas"
      "ec2-instance-selector" # contribute to nixpkgs?
    ];
    casks = [
      # make macos usable
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "mountain-duck"
      "secretive"
      "steermouse"
      "tailscale-app"
      #"zed@preview"
      "zed"
      "rectangle"
      "monitorcontrol"

      # tools, nice to have
      "alfred"
      "little-snitch"
      "macfuse"
      "mullvad-vpn"
      "utm"

      # apps
      "calibre"
      "chatgpt"
      "claude"
      "cursor"
      "discord"
      "google-chrome"
      "granola"
      "jetbrains-toolbox"
      "ledger-live"
      "linear-linear"
      "lm-studio"
      "mactex"
      "notion"
      "notion-calendar"
      "obsidian"
      "proton-mail"
      "signal"
      "skim"
      "slack"
      "standard-notes"
      "steam"
      "stolendata-mpv"
      "superhuman"
      "ticktick"
      "tor-browser"
      "uhk-agent"
      "witsy"

      # dislike but need :(
      "element"
      # "loom"
      "zoom"
      "google-drive"
    ];

    # manually installed
    # - Epubor Ultimate
  };
}
