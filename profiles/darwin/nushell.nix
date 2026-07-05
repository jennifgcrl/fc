# System-level nushell support for nix-darwin: sets PATH and the environment for
# nushell the way nix-darwin already does for zsh/fish, which it doesn't do for
# nushell -- see https://github.com/nix-darwin/nix-darwin/issues/1770.
#
# The generated config (see profiles/nushell-vendor.nix) must live in
# /Library/Application Support/nushell/vendor/autoload: that path is hardcoded
# into nushell on macOS, so it is found on a cold GUI login before any
# XDG_DATA_DIRS is set. The nix profile's own vendor autoload dirs only appear on
# $nu.vendor-autoload-dirs once XDG_DATA_DIRS already points at them, which is
# exactly the chicken-and-egg this works around.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.programs.nushell;

  vendorFile = import ../nushell-vendor.nix {inherit lib pkgs;} {
    platform = "darwin";
    inherit (config) environment;
  };
in {
  options.programs.nushell = {
    enable = lib.mkEnableOption "nushell, wiring the nix-darwin environment into its vendor autoload";
    package = lib.mkPackageOption pkgs "nushell" {};
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    system.activationScripts.postActivation.text = ''
      echo "linking nushell nix-darwin environment" >&2
      mkdir -p "/Library/Application Support/nushell/vendor/autoload"
      ln -sfn ${vendorFile} "/Library/Application Support/nushell/vendor/autoload/nix-darwin.nu"
    '';
  };
}
