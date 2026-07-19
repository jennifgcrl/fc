{
  self,
  home-manager,
  pkgs,
  lib,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    ./nushell.nix
    ../common
    ../common/graphical.nix
  ];

  # determinate
  nix.enable = false;
  nix.gc.automatic = lib.mkForce false;

  environment.etc.nix-darwin.source = "/Users/jennifer/code/fc";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;
  # will be deprecated; currently needed for system.defaults.*
  system.primaryUser = "jennifer";
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Give nushell the same PATH/environment nix-darwin sets up for zsh (see
  # ./nushell.nix).
  programs.nushell.enable = true;

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
    brews = [
      "mas"
    ];
    casks = [
      "alfred"
      "chatgpt"
      "claude"
      "discord"
      "ghostty"
      "google-chrome"
      "google-drive"
      "hammerspoon"
      "istat-menus"
      "ledger-wallet"
      "notion"
      "notion-calendar"
      "obsidian"
      "proton-mail"
      "rectangle"
      "secretive"
      "signal"
      "slack"
      "standard-notes"
      "steermouse"
      "superhuman"
      "tailscale-app"
      "zed"
      "zoom"
    ];
  };
}
