{
  pkgs,
  niri,
  claude-desktop,
  ...
}: {
  imports = [
    niri.nixosModules.niri
  ];

  nixpkgs.overlays = [niri.overlays.niri];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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

  hardware.i2c.enable = true;

  fonts.packages = with pkgs; [
    departure-mono
    dm-mono
    noto-fonts
    recursive
  ];

  services.flatpak.enable = true;

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home-manager.users.jennifer = {
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.niri
      ];
    };

    home.packages = with pkgs; [
      xwayland-satellite # niri uses this for xwayland
      xorg.xlsclients
      nautilus # gnome or gtk portal uses this for dialogs
      gnome-keyring # niri
      j4-dmenu-desktop
      bemenu
      zed-editor-fhs
      code-cursor
      jetbrains.datagrip
      wl-clipboard-rs
      glances
      ddcutil
      claude-desktop.packages.${system}.claude-desktop
    ];

    programs = {
      zsh = {
        shellAliases = {
          zed = "zeditor";
        };
      };
      ghostty = {
        enable = true;
        settings = {
          theme = "NvimDark";
          # macos-option-as-alt = true;
          # macos-titlebar-style = "tabs";
          #font-family = "DM Mono";
          #font-family = "Triskweline";
          font-family = "Departure Mono";
          font-size = 14;
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
      waybar.enable = true;
    };

    services = {
      swww.enable = true;
      espanso = {
        # maybe broken? https://github.com/NixOS/nixpkgs/pull/328890
        enable = false;
        configs = {
          default = {
            keyboard_layout = {
              layout = "us";
              variant = "dvorak";
            };
          };
        };
        matches = {
          base = {
            matches = [
              {
                trigger = "`e";
                replace = "jennifer@jezh.me";
              }
              {
                trigger = "`j";
                replace = "jennifer";
              }
            ];
          };
        };
      };
      gammastep = {
        enable = true;
        # san francisco https://www.latlong.net/
        longitude = -122.431297;
        latitude = 37.773972;
      };
      fnott = {
        enable = true;
        settings = {
          # i think this might be configured wrong

          main = {
            title-color = "a5adceff";
            summary-color = "c6d0f5ff";
            body-color = "c6d0f5ff";
            background = "303446ff";
            border-color = "8caaeeff";
            progress-bar-color = "737994ff";
          };

          critical = {
            border-color = "ef9f76ff";
          };
        };
      };
    };
  };
}
