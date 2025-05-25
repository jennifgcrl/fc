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
        paths = fonts.packages ++ [
          # Add your cursor themes and icon packages here
          # bibata-cursors
          # gnome.gnome-themes-extra
          # etc.
        ];
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

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    nautilus
    gnome-keyring

    xwayland-satellite
  ];

  home-manager.users.jennifer = {
    home.packages = with pkgs; [
      j4-dmenu-desktop
      bemenu
      zed-editor-fhs
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
      swaylock.enable = true;
    };

    services = {
      swww.enable = true;
      fnott = {
        enable = true;
        settings = {
          main = {
            title-color="a5adceff";
            summary-color="c6d0f5ff";
            body-color="c6d0f5ff";
            background="303446ff";
            border-color="8caaeeff";
            progress-bar-color="737994ff";
          };

          critical = {
            border-color="ef9f76ff";
          };
        };
      };
    };
  };
}
