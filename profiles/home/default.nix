{...}: {
  home-manager.users.jennifer = {
    pkgs,
    lib,
    config,
    ...
  }: {
    home.username = "jennifer";

    xdg.enable = true;

    home.packages = with pkgs; [
      watchman
      atool
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

      # nix
      alejandra
      nixd
      nil

      # python
      uv
      basedpyright
      ty
      ruff
      python312Packages.python-lsp-server

      #misc langs
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
      google-cloud-sdk
      kubectl
      kubecolor
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
        # TODO: enable this after setting up secrets
        # ".npmrc".text = ''
        #   prefix=~/.npm-packages
        # '';
      }
      # // lib.optionalAttrs pkgs.stdenv.isDarwin {
      #   # this is to get around the chicken-and-egg problem of nushell not knowing
      #   # to use XDG base dirs before reading its config
      #   # maybe figure out the correct incantation to get this path out of the nix store
      #   "Library/Application Support/nushell" = {
      #     source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nushell";
      #     recursive = true;
      #   };
      # }
      ;

    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        userName = "Jennifer Zhou";
        userEmail = "jennifer@jezh.me";

        extraConfig = {
          pull.rebase = true;
          push.autoSetupRemote = true;
          submodule.recurse = true;
          merge.conflictstyle = "zdiff3";
        };

        aliases = {
          co = "checkout";
          ci = "commit";
          st = "status";
          br = "branch";
        };
      };

      direnv = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
        config = {
          warn_timeout = 0;
        };
      };
      home-manager.enable = true;
      zsh = {
        enable = true;
        syntaxHighlighting = {
          enable = true;
          styles = {
            comment = "none";
          };
        };
        autosuggestion.enable = true;
        sessionVariables = {
          WORDCHARS = "";

          # an unfortunate number of programs have the incorrect fallback logic
          # of only using xdg base dirs if the env vars are explicitly set :(
          XDG_CONFIG_HOME = "$HOME/.config";
          XDG_CACHE_HOME = "$HOME/.cache";
          XDG_DATA_HOME = "$HOME/.local/share";
          XDG_STATE_HOME = "$HOME/.local/state";
        };
        shellAliases = {
          k = "kubecolor";
          kubectl = "kubecolor";
          kg = "kubecolor get";
          kd = "kubecolor describe";
          kD = "kubecolor delete";
          gp = "git push";
          c = "claude";
        };
        initContent = lib.mkMerge [
          (
            # https://github.com/NixOS/nixpkgs/pull/119052
            lib.mkOrder 1000 ''
              bindkey -e
              bindkey \^U backward-kill-line
              setopt printexitvalue
              setopt dvorak
              setopt interactivecomments
              setopt completeinword
              setopt correct
              setopt extendedglob
              setopt extendedhistory
              setopt incappendhistory
              setopt longlistjobs
              setopt nohup
              setopt transientrprompt

              path+=~/bin
              path+=~/go/bin
              path+=~/.bun/bin
              path+=''${XDG_DATA_HOME}/npm/bin

              r() {
                temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
                ranger --choosedir="$temp_file" -- "''${@:-$PWD}"
                if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
                  cd -- "$chosen_dir"
                fi
                rm -f -- "$temp_file"
              }
            ''
          )
        ];
      };
      nushell = {
        enable = true;
        settings = {
          show_banner = false;
          history.isolation = false;
        };
        shellAliases = {
          k = "kubecolor";
          kubectl = "kubecolor";
          kg = "kubecolor get";
          kd = "kubecolor describe";
          kD = "kubecolor delete";
          gp = "git push";
          c = "claude";
        };
        plugins = with pkgs; [
          nushellPlugins.formats
          nushellPlugins.query
          nushellPlugins.polars
        ];
        extraConfig = ''
          use std/util "path add"

          ${
            lib.optionalString pkgs.stdenv.isDarwin
            # TODO: investigate why these aren't added automatically by nix-darwin+home-manager
            # TODO: move /usr/local/bin and /opt/homebrew/bin to darwin/
            ''
              path add "/opt/homebrew/bin"
              path add "/usr/local/bin"
              path add "/run/current-system/sw/bin"
              path add "/nix/var/nix/profiles/default/bin"
              path add "/etc/profiles/per-user/jennifer/bin"
              path add "~/.nix-profile/bin"
            ''
          }

          path add "~/.local/share/npm/bin"
          path add "~/.bun/bin"
          path add "~/go/bin"
          path add "~/bin"

          def --env r [] {
            ranger --choosedir=/tmp/rangerdir; cd (cat /tmp/rangerdir); rm /tmp/rangerdir
          }
        '';
        environmentVariables = {
          # TODO: figure out how home-manager's xdg config works
          # feels like it should be redundant with xdg.enable = true; but these aren't being set
          XDG_CONFIG_HOME = "/home/jennifer/.config";
          XDG_CACHE_HOME = "/home/jennifer/.cache";
          XDG_DATA_HOME = "/home/jennifer/.local/share";
          XDG_STATE_HOME = "/home/jennifer/.local/state";
        };
      };
      tmux = {
        enable = true;
        mouse = true;
        focusEvents = true;
        keyMode = "vi";
        baseIndex = 1;
        escapeTime = 0;
        terminal = "tmux-256color";
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
          bind-key -n M-Tab select-pane -t :.+
        '';
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
        # no fzf for nu yet: https://github.com/junegunn/fzf/issues/4122
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };
      eza = {
        enable = true;
        enableZshIntegration = true;
        # enableNushellIntegration = true;
      };
      carapace = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };
      bat.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      jq.enable = true;
      htop.enable = true;
      ranger.enable = true;
      gh.enable = true;
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        extraLuaConfig = ''
          vim.opt.clipboard = 'unnamedplus'
          vim.opt.number = true
          vim.opt.relativenumber = true
        '';
      };
    };

    home.stateVersion = "25.05";
  };
}
