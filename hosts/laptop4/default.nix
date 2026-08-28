{lib, ...}: let
  # Casks that break when Homebrew replaces the app bundle underneath them:
  # both self-update, and a `brew upgrade` swap leaves their privileged
  # helpers/kexts mismatched against the new app. They stay declared below so
  # `onActivation.cleanup = "zap"` keeps them, but HOMEBREW_BUNDLE_CASK_SKIP
  # makes `brew bundle` leave them alone -- each app updates itself instead.
  # Note: skipped casks are never *installed* by brew bundle either, so on a
  # fresh machine install them once by hand with `brew install --cask <name>`.
  selfUpdatingCasks = [
    "parallels"
    "docker-desktop"
  ];
in {
  imports = [
    ../../profiles/darwin
    ../../profiles/home
  ];

  # nix-darwin
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 7;

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
    onActivation.extraEnv.HOMEBREW_BUNDLE_CASK_SKIP =
      lib.concatStringsSep " " selfUpdatingCasks;
    casks =
      [
        "figma"
        "gcloud-cli"
        "granola"
        "linear"
        "lm-studio"
        "mactex"
        "microsoft-teams"
        "steam"
      ]
      ++ selfUpdatingCasks;
  };
}
