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
      jujutsu = {
        enable = true;
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
        extraLogin = ''
          if "_SOURCED_BASH" not-in $env {
            load-env (bash -l -i -c "nu -c '$env | to yaml'" | from yaml | reject
              config _ FILE_PWD PWD SHLVL CURRENT_FILE
              STARSHIP_SHELL
              STARSHIP_SESSION_KEY
              PROMPT_COMMAND
              PROMPT_COMMAND_RIGHT
              PROMPT_INDICATOR
              PROMPT_INDICATOR_VI_INSERT
              PROMPT_INDICATOR_VI_NORMAL
              PROMPT_MULTILINE_INDICATOR
              TRANSIENT_PROMPT_COMMAND_RIGHT
              TRANSIENT_PROMPT_MULTILINE_INDICATOR
            )
            $env._SOURCED_BASH = true
          }
        '';
        extraConfig = lib.mkMerge [
          (lib.mkOrder 500 ''
            $env.XDG_CONFIG_HOME = $"($env.HOME)/.config";
            $env.XDG_CACHE_HOME = $"($env.HOME)/.cache";
            $env.XDG_DATA_HOME = $"($env.HOME)/.local/share";
            $env.XDG_STATE_HOME = $"($env.HOME)/.local/state";

            use std/util "path add"
            path add $"($env.XDG_DATA_HOME)/npm/bin"
            path add ~/.bun/bin
            path add ~/go/bin
            path add ~/bin
          '')
          (lib.mkOrder 1000 ''
            def --env r [] {
              ranger --choosedir=/tmp/rangerdir; cd (cat /tmp/rangerdir); rm /tmp/rangerdir
            }
          '')
        ];
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
        # no fzf for nu yet: https://github.com/junegunn/fzf/issues/4122
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
