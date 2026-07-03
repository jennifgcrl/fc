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
        path add ~/.lmstudio/bin
        path add ~/.cache/.bun/bin
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
    # Homebrew 5.1+ requires --force for `brew bundle --cleanup`; this pin of
    # nix-darwin doesn't add it yet. Drop once the input is bumped past the fix.
    onActivation.extraFlags = ["--force"];
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Microsoft Excel" = 462058435;
      "Microsoft Word" = 462054704;
      "Synctrain" = 6553985316;
      "WhatsApp" = 310633997;
      "Xcode" = 497799835;
      "Trace" = 6768724888;
    };
    taps = [
      # "angristan/tap"
    ];
    brews = [
      "mas"
      "coder"
    ];
    casks = [
      "alfred"
      "chatgpt"
      "claude"
      "discord"
      "figma"
      "gcloud-cli"
      "ghostty"
      "google-chrome"
      "google-drive"
      "granola"
      "hammerspoon"
      "istat-menus"
      "ledger-wallet"
      "linear"
      "lm-studio"
      "mactex"
      "microsoft-teams"
      "mullvad-vpn"
      "notion"
      "notion-calendar"
      "obsidian"
      "parallels"
      "proton-mail"
      "rectangle"
      "secretive"
      "signal"
      "slack"
      "standard-notes"
      "steam"
      "steermouse"
      "superhuman"
      "tailscale-app"
      "tor-browser"
      "zed"
      "zoom"

      "antigravity"
    ];
  };
}
