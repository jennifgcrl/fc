{
  pkgs,
  lib,
  ...
}: {
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

    # fonts
    departure-mono
    noto-fonts
    recursive

    # nix
    alejandra
    nixd
    nil

    # python
    uv
    basedpyright
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
      source = ./scripts/update;
      executable = true;
    };
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
    };
    bash.enable = true;
    home-manager.enable = true;
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      sessionVariables = {
        SSH_AUTH_SOCK = "/Users/jennifer/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        WORDCHARS = "";
      };
      shellAliases = {
        # https://github.com/NixOS/nixpkgs/pull/119052
        k = "kubectl";
        gp = "git push";
        zed = "zed-preview";
        r = ". .ranger-wrapped";
      };
      initContent = lib.mkMerge [
        (
          lib.mkOrder 1000 ''
            bindkey -e
            bindkey \^U backward-kill-line
            setopt printexitvalue
            setopt dvorak
            setopt interactivecomments

            path+=~/bin
            path+=~/go/bin
            path+=~/.bun/bin
            path+=~/.npm-packages/bin
            path+=~/Library/Application\ Support/JetBrains/Toolbox/scripts
            path+=~/.cache/lm-studio/bin
            path+=/opt/homebrew/bin
          ''
        )
      ];
    };
    tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 0;
      terminal = "tmux-256color";
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.tokyo-night-tmux;
          extraConfig = ''
            set -g @theme_variation 'storm'
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
}
