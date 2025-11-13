{
  home-manager,
  pkgs,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    ../common
    ../common/graphical.nix
  ];

  home-manager.users.jennifer = {
    programs = {
      nushell = {
        shellAliases = {
          # zed = "zed-preview";
        };
      };
    };
  };
}
