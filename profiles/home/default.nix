{...}: {
  home-manager.users.jennifer = {
    pkgs,
    lib,
    config,
    osConfig,
    ...
  }: {
    home.stateVersion = "26.05";

    home.username = "jennifer";

    xdg = {
      enable = true;
      # On Linux, inject the system environment into nushell via a vendor
      # autoload file in ~/.local/share/nushell/vendor/autoload (nushell's
      # always-scanned data dir). macOS is handled system-wide by
      # profiles/darwin/nushell.nix. See profiles/nushell-vendor.nix.
      dataFile = lib.optionalAttrs (!pkgs.stdenv.isDarwin) {
        "nushell/vendor/autoload/nix-env.nu".source = import ../nushell-vendor.nix {inherit lib pkgs;} {
          platform = "nixos";
          inherit (osConfig) environment;
        };
      };
    };

    home.packages = with pkgs;
      [
        atool # replace with ouch?
        ouch
        unzip
        curl
        eternal-terminal
        hwatch
        gdu
        podman
        doggo
        uutils-coreutils-noprefix
        hyperfine
        file
        glances
        nix-index
        mtr

        # nix
        alejandra
        nixd
        nil

        # python
        uv
        ty

        #misc langs
        rustup
        taplo
        buf
        go
        terraform-ls
        terraform

        # node
        nodejs
        bun

        # clis
        awscli2
        kubectl
        kubecolor
        stern
      ]
      ++ lib.optionals (!pkgs.stdenv.isDarwin) [
        google-cloud-sdk
      ];

    home.file =
      {
        "bin/upd" = {
          source = ../../scripts/update;
          executable = true;
        };
        "bin/wip" = {
          source = ../../scripts/wip;
          executable = true;
        };
      }
      // lib.optionalAttrs pkgs.stdenv.isDarwin {
        # this is to get around the chicken-and-egg problem of nushell not knowing
        # to use XDG base dirs before reading its config
        # maybe figure out the correct incantation to get this path out of the nix store
        "Library/Application Support/nushell" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nushell";
          recursive = true;
        };
      };

    programs = {
      home-manager.enable = true;

      git = {
        enable = true;
        lfs.enable = true;

        settings = {
          user.name = "Jennifer Zhou";
          user.email = "jennifer@jezh.me";
          pull.rebase = true;
          push.autoSetupRemote = true;
          submodule.recurse = true;
          merge.conflictstyle = "zdiff3";
          alias = {
            co = "checkout";
            ci = "commit";
            st = "status";
            br = "branch";
          };
        };
      };

      direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
        config = {
          warn_timeout = 0;
        };
      };
      nushell = {
        enable = true;
        settings = {
          show_banner = false;
          history.isolation = false;
        };
        shellAliases = {
          kubectl = "kubecolor";
          k = "kubecolor";

          kg = "kubecolor get";
          kgp = "kubecolor get po";
          kgs = "kubecolor get sts";
          kgd = "kubecolor get deployment";
          kgn = "kubecolor get no";
          kgnc = "kubecolor get nodeclaim";

          kd = "kubecolor describe";
          kdp = "kubecolor describe po";
          kds = "kubecolor describe sts";
          kdd = "kubecolor describe deployment";
          kdn = "kubecolor describe no";
          kdnc = "kubecolor describe nodeclaim";

          kD = "kubecolor delete";
          kDp = "kubecolor delete po";
          kDs = "kubecolor delete sts";
          kDd = "kubecolor delete deployment";
          kDn = "kubecolor delete no";
          kDnc = "kubecolor delete nodeclaim";

          gp = "git push";

          c = "claude";

          mkdir = "^mkdir";
        };
        plugins = with pkgs; [
          nushellPlugins.formats
          nushellPlugins.query
          nushellPlugins.polars
        ];
        # PATH and the system environment are injected via nushell's vendor
        # autoload: on macOS by profiles/darwin/nushell.nix, on Linux by the
        # nix-env.nu written to xdg.dataFile above.
        extraConfig = lib.mkOrder 500 ''
          $env.ENV_CONVERSIONS = $env.ENV_CONVERSIONS | merge {
              "XDG_DATA_DIRS": {
                  from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
                  to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
              }
          }

          use std/util "path add"

          $env.XDG_CONFIG_HOME = $"($env.HOME)/.config";
          $env.XDG_CACHE_HOME = $"($env.HOME)/.cache";
          $env.XDG_DATA_HOME = $"($env.HOME)/.local/share";
          $env.XDG_STATE_HOME = $"($env.HOME)/.local/state";

          $env.EDITOR = "nvim";

          path add $"($env.XDG_DATA_HOME)/npm/bin"
          path add ~/.local/bin
          path add ~/go/bin
          path add ~/bin
        '';
      };
      tmux = {
        enable = true;
        mouse = true;
        focusEvents = true;
        keyMode = "vi";
        baseIndex = 1;
        escapeTime = 0;
        terminal = "tmux-256color";
        historyLimit = 9999999;
        plugins = with pkgs; [
          {
            plugin = tmuxPlugins.tokyo-night-tmux;
            extraConfig = ''
              set -g @theme_variation 'storm'
              set -g @tokyo-night-tmux_show_hostname 1
            '';
          }
          tmuxPlugins.fzf-tmux-url
        ];
        extraConfig = ''
          set -s set-clipboard on
          bind-key -n M-Tab select-pane -t :.+
        '';
      };
      fzf = {
        enable = true;
        enableNushellIntegration = true;
      };
      starship = {
        enable = true;
        enableNushellIntegration = true;
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      jq.enable = true;
      htop.enable = true;
      yazi = {
        enable = true;
        enableNushellIntegration = true;
        plugins = with pkgs.yaziPlugins; {
          smart-enter.package = smart-enter;
          chmod.package = chmod;
          bookmarks = {
            package = bookmarks;
            setup = true;
            settings = {
              persist = "all";
            };
          };
        };
        keymap.mgr.prepend_keymap = [
          {
            on = "<Enter>";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = ["m"];
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = ["'"];
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = ["b" "d"];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = ["b" "D"];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
        ];
      };
      gh.enable = true;
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        initLua = ''
          vim.opt.clipboard = 'unnamedplus'
          vim.opt.number = true
          vim.opt.relativenumber = true
        '';
      };
    };
  };
}
