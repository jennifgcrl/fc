{home-manager, ...}: {
  imports = [
    ../common
    home-manager.darwinModules.home-manager
  ];

  home-manager.users.jennifer = {
    programs = {
      zsh = {
        shellAliases = {
          zed = "zed-preview";
        };
      };
    };
  };
}
