{
  home-manager,
  pkgs,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    ./nushell.nix
    ../common
    ../common/graphical.nix
  ];

  # Give nushell the same PATH/environment nix-darwin sets up for zsh (see
  # ./nushell.nix).
  programs.nushell.enable = true;

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
