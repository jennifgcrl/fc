{pkgs, niri, ...}: rec {
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

  services.flatpak.enable = true;

  # allow flatpaks to use system fonts
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregated = pkgs.buildEnv {
        name = "system-fonts-and-icons";
        paths = fonts.packages ++ (with pkgs; [
          # Add your cursor themes and icon packages here
          # bibata-cursors
          # gnome.gnome-themes-extra
          # etc.
        ]);
        pathsToLink = [ "/share/fonts" "/share/icons" ];
    };
  in {
    "/usr/share/fonts" = mkRoSymBind "${aggregated}/share/fonts";
    "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # niri defaults require:
  # * portal-gnome
  #   * nautilus
  # * portal-gtk
  # * gnome-keyring
  # TODO: maybe look into niri-portals.conf & switch to kde equivs

  xdg.portal = {
    # xdgOpenUsePortal = true;
    enable = true;
    wlr.enable = true;
    # lxqt.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    # xdg-desktop-portal-gnome
    # xdg-desktop-portal-gtk
    # xdg-desktop-portal-hyprland
    # pkgs.kdePackages.xdg-desktop-portal-kde
    # xdg-desktop-portal-wlr
    nautilus
    egl-wayland
    gnome-keyring
  ];

  home-manager.users.jennifer = {
    home.packages = with pkgs; [
      gnome-software
      j4-dmenu-desktop
      bemenu
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
          #background-opacity = 0.80;
          #background-blur = true;
          window-step-resize = true;
          window-padding-x = 0;
          window-padding-y = 0;
          window-padding-balance = true;
          #minimum-contrast = 1.3;
          cursor-style = "block";
          shell-integration-features = "no-cursor";
          window-decoration = "none";
        };
      };
    };
  };
}
