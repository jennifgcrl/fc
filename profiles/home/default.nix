{
  pkgs,
  lib,
  ...
}: {
  home-manager.users.jennifer = {
    home.username = "jennifer";

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

      # fonts
      # TODO: maybe put this in fonts.packages?
      departure-mono
      dm-mono
      noto-fonts
      recursive

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
    ];

    home.file = {
      "bin/update" = {
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
    };

    programs = {
      git = {
        enable = true;
        userName = "Jennifer Zhou";
        userEmail = "jennifer@jezh.me";

        extraConfig = {
          pull.rebase = true;
          push.autoSetupRemote = true;
          submodule.recurse = true;
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
        };
        shellAliases = {
          k = "kubectl";
          kg = "kubectl get";
          kd = "kubectl describe";
          gp = "git push";
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
              path+=~/.npm-packages/bin

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
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
      };
      eza = {
        enable = true;
        enableZshIntegration = true;
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
