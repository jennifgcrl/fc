{pkgs, niri, ...}: {
  imports = [
    niri.nixosModules.niri
  ];

  nixpkgs.overlays = [niri.overlays.niri];

  programs.niri.enable = true;

  fonts.packages = with pkgs; [
    departure-mono
    dm-mono
    noto-fonts
    recursive
  ];

  # environment.variables.NIXOS_OZONE_WL = "1";

  home-manager.users.jennifer = {
    home.packages = with pkgs; [
      google-chrome
    ];

    programs = {
      ghostty = {
        enable = true;
        settings = {
          theme = "NvimDark";
          # macos-option-as-alt = true;
          # macos-titlebar-style = "tabs";
          #font-family = "DM Mono";
          #font-family = "Triskweline";
          font-family = "Departure Mono";
          font-size = 12;
          background-opacity = 0.80;
          background-blur = true;
          window-step-resize = true;
          window-padding-x = 0;
          window-padding-y = 0;
          window-padding-balance = true;
          #minimum-contrast = 1.3;
          cursor-style = "block";
          shell-integration-features = "no-cursor";
        };
      };
    };
  };
}
