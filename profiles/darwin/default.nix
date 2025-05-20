{home-manager, ...}: {
  imports = [
    ../common
    home-manager.darwinModules.home-manager
  ];
}
