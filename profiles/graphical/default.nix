{niri, ...}: {
  imports = [
    niri.nixosModules.niri
  ];

  nixpkgs.overlays = [niri.overlays.niri];

  programs.niri.enable = true;

  # environment.variables.NIXOS_OZONE_WL = "1";

  # home-manager.users.jennifer = {
  #   programs.niri.settings = {
  #   };
  # };
}
