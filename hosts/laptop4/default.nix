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

  nix.enable = false;
  nix.gc.automatic = lib.mkForce false;

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
    uid = 501;
  };

  home-manager.users.jennifer = {
    home.packages = with pkgs; [
      rustup
      uv
    ];

    programs.nushell = {
      environmentVariables = {
        # SSH_SK_PROVIDER = "/usr/lib/ssh-keychain.dylib";
        SSH_AUTH_SOCK = "/Users/jennifer/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      };
      extraConfig = lib.mkOrder 501 ''
        path add ~/.cache/lm-studio/bin
        path add /opt/homebrew/bin
        path add /Library/TeX/texbin
        path add /opt/homebrew/share/google-cloud-sdk/bin
      '';
    };
  };

  # macos
  system.defaults.NSGlobalDomain.NSWindowShouldDragOnGesture = true;
  system.defaults.NSGlobalDomain.NSScrollAnimationEnabled = false;
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
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Synctrain" = 6553985316;
      "WhatsApp" = 310633997;
      "Xcode" = 497799835;
    };
    taps = [
      "angristan/tap"
    ];
    brews = [
      "mas"
    ];
    casks = [
      # make macos usable
      "ghostty"
      "hammerspoon"
      "macthrottle"
      "secretive"
      "steermouse"
      "tailscale-app"
      "zed"
      "rectangle"

      # tools, nice to have
      "alfred"
      "mullvad-vpn"

      # apps
      "claude"
      "discord"
      "google-chrome"
      "granola"
      "ledger-wallet"
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
      # "stolendata-mpv"
      "superhuman"
      "tor-browser"

      # dislike but need :(
      "zoom"
      "google-drive"
      "microsoft-teams"

      "gcloud-cli"
      "figma"
    ];
  };
}
