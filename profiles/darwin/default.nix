{
  home-manager,
  pkgs,
  ...
}: {
  imports = [
    home-manager.darwinModules.home-manager
    ../common
    ../common/graphical.nix
  ];

  home-manager.sharedModules = [
    ({
      lib,
      config,
      ...
    }: {
      # Disable old style linking of applications in home-manager
      targets.darwin.linkApps.enable = lib.mkForce false;
      home.activation.copyApplications = let
        targetDir = "${config.home.homeDirectory}/Applications/Home Manager Apps";
        homeApps = pkgs.buildEnv {
          name = "home-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
      in
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          # Set up home applications.
          echo "setting up ${targetDir}..." >&2

          # Clean up old style symlinks
          if [ -e "${targetDir}" ] && [ -L "${targetDir}" ]; then
            rm "${targetDir}"
          fi
          mkdir -p "${targetDir}"

          rsyncFlags=(
            --checksum
            --copy-unsafe-links
            --archive
            --delete
            --chmod=-w
            --no-group
            --no-owner
          )
          ${lib.getExe pkgs.rsync} "''${rsyncFlags[@]}" ${homeApps}/Applications/ "${targetDir}"
        '';
    })
  ];

  home-manager.users.jennifer = {
    programs = {
      nushell = {
        shellAliases = {
          zed = "zed-preview";
        };
      };
    };
  };
}
