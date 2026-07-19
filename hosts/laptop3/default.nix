{...}: {
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
    ];
    casks = [
      "steam"
      "tor-browser"
    ];
  };
}
