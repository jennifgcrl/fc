{
  self,
  lib,
  pkgs,
  ...
}: let
  # Personal tailnet, alongside the work tailnet that tailscale-app runs. Both
  # tailnets hand out addresses from 100.64.0.0/10, so a second TUN would fight
  # tailscale-app over routes; instead this is an unprivileged userspace
  # tailscaled, reached by name through `tailscale nc` (ssh) or its SOCKS5
  # proxy on localhost:1055 (everything else). nixpkgs rather than the brew
  # formula so its `tailscale` doesn't shadow tailscale-app's on PATH.
  # One-time: `tailscale-personal up`.
  tailscalePersonalDir = "/Users/jennifer/.local/share/tailscale-personal";
  tailscalePersonalSocket = "${tailscalePersonalDir}/tailscaled.sock";
  tailscalePersonal = pkgs.writeShellScriptBin "tailscale-personal" ''
    exec ${pkgs.tailscale}/bin/tailscale --socket=${tailscalePersonalSocket} "$@"
  '';

  # Casks that break when Homebrew replaces the app bundle underneath them:
  # both self-update, and a `brew upgrade` swap leaves their privileged
  # helpers/kexts mismatched against the new app. They stay declared below so
  # `onActivation.cleanup = "uninstall"` keeps them, but HOMEBREW_BUNDLE_CASK_SKIP
  # makes `brew bundle` leave them alone -- each app updates itself instead.
  # Note: skipped casks are never *installed* by brew bundle either, so on a
  # fresh machine install them once by hand with `brew install --cask <name>`.
  selfUpdatingCasks = [
    "parallels"
  ];
in {
  imports = [
    ../../profiles/darwin
    ../../profiles/home
  ];

  # nix-darwin
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 7;

  # user
  # unfortunately still need to run chsh manually
  users.users.jennifer = {
    home = "/Users/jennifer";
    uid = 501;
  };

  launchd.user.agents.tailscale-personal = {
    script = ''
      mkdir -p ${tailscalePersonalDir}
      exec ${pkgs.tailscale}/bin/tailscaled \
        --tun=userspace-networking \
        --statedir=${tailscalePersonalDir} \
        --socket=${tailscalePersonalSocket} \
        --port=0 \
        --socks5-server=localhost:1055
    '';
    # otherwise logs land in ~/.local/share/tailscale
    environment.TS_LOGS_DIR = tailscalePersonalDir;
    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
    };
  };

  home-manager.users.jennifer = {
    home.packages = [tailscalePersonal];
    # ~/.ssh/config itself stays unmanaged (coder rewrites it); it needs
    # `Include config.d/*` at the top to pick this up.
    home.file.".ssh/config.d/tailscale-personal".text = ''
      Host ${lib.concatStringsSep " " (builtins.attrNames self.nixosConfigurations)}
        ProxyCommand ${tailscalePersonal}/bin/tailscale-personal nc %h %p
    '';
  };

  homebrew = {
    masApps = {
    };
    brews = [
      "coder"
      "container"
    ];
    onActivation.extraEnv.HOMEBREW_BUNDLE_CASK_SKIP =
      lib.concatStringsSep " " selfUpdatingCasks;
    casks =
      [
        "gcloud-cli"
        "granola"
        "lm-studio"
        "lm-studio-bionic"
        "microsoft-teams"
        "steam"
        "t3-code"
        "grok-bot"
      ]
      ++ selfUpdatingCasks;
  };
}
