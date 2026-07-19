{...}: {
  imports = [
    ../../profiles/darwin
    ../../profiles/home
  ];

  # nix-darwin
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

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
    ];
  };
}
