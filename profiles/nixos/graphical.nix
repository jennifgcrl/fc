{
  pkgs,
  niri,
  claude-desktop,
  ...
}: {
  imports = [
    niri.nixosModules.niri
    ../common/graphical.nix
  ];

  nixpkgs.overlays = [niri.overlays.niri];

  programs.nix-ld = {
    libraries = with pkgs; [
      # for Mission Center
      systemd
      musl
      libgbm
      vulkan-loader

      alsa-lib
    ];
  };

  # wifi
  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    IPv6 = {
      Enabled = true;
    };
    Settings = {
      AutoConnect = true;
    };
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

  # display
  hardware.i2c.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      clock = "%c %z";
      brightness_down_key = "null";
      brightness_up_key = "null";
    };
    x11Support = false;
  };

  fonts.packages = with pkgs; [
    departure-mono
    dm-mono
    noto-fonts
    recursive
  ];

  services.flatpak.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home-manager.users.jennifer = {lib, ...}: {
    home.file."bin/update-bing-wallpaper" = {
      source = ../../scripts/update-bing-wallpaper;
      executable = true;
    };
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      configPackages = [
        pkgs.niri
      ];
    };

    xdg.mimeApps = {
      enable = true;
      # check ~/.local/share/flatpak/exports/share
      defaultApplications = let
        webBrowser = ["com.google.Chrome.desktop"];
      in {
        "text/html" = webBrowser;
        "x-scheme-handler/http" = webBrowser;
        "x-scheme-handler/https" = webBrowser;
        "x-scheme-handler/about" = webBrowser;
        "x-scheme-handler/unknown" = webBrowser;
      };
    };

    home.packages = with pkgs; [
      # desktop environment
      xwayland-satellite # niri uses this for xwayland
      xorg.xlsclients
      nautilus # gnome or gtk portal uses this for dialogs
      gnome-keyring # niri
      j4-dmenu-desktop
      bemenu
      wl-clipboard-rs
      ddcutil
      zed-editor-fhs

      # apps
      code-cursor
      jetbrains.datagrip
      jetbrains.pycharm-professional
      claude-desktop.packages.${system}.claude-desktop
      imv
    ];

    programs = {
      nushell = {
        shellAliases = {
          zed = "zeditor";
        };
        extraConfig = lib.mkOrder 501 ''
          $env.XDG_DATA_DIRS = ($env | get --optional XDG_DATA_DIRS | default [] | split row (char esep) | append /usr/share | append /var/lib/flatpak/exports/share | append $"($env.HOME)/.local/share/flatpak/exports/share")
          $env.NIXOS_XDG_OPEN_USE_PORTAL = true
        '';
      };
      ghostty = {
        enable = true;
        settings = {
          theme = "NvimDark";
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
      # chromium.enable = true;
      swaylock.enable = true;
      waybar = {
        enable = true;
        # TODO: debug this not working
        #systemd.enable = true;
      };
      zathura = {
        enable = true;
        options = {
          selection-clipboard = "clipboard";
        };
      };
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
      wob.enable = true;
      playerctld.enable = true;
    };

    systemd.user = {
      services.update-bing-wallpaper = {
        Unit = {
          Description = "Update Bing daily wallpaper";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "%h/bin/update-bing-wallpaper";
        };
      };
      timers.update-bing-wallpaper = {
        Unit = {
          Description = "Run update-bing-wallpaper periodically";
        };
        Timer = {
          OnCalendar = "daily";
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };
  };
}
