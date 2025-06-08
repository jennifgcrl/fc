{
  description = "jennifcrl systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-alien.url = "github:thiagokokada/nix-alien";

    niri.url = "github:sodiboo/niri-flake";

    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
    claude-desktop.inputs.nixpkgs.follows = "nixpkgs";
    # claude-desktop.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    lanzaboote,
    nix-alien,
    niri,
    claude-desktop,
    ...
  }: let
    forAllSystems = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ] (system: f system);

    forAllSystemsPkgs = f:
      forAllSystems (system: f nixpkgs.legacyPackages.${system});

    darwinSystem = hostName:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit self hostName home-manager;
        };
        modules = [
          ./hosts/${hostName}
        ];
      };

    nixosSystem = hostName:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self hostName home-manager lanzaboote nix-alien niri claude-desktop;
        };
        modules = [
          ./hosts/${hostName}
        ];
      };
  in {
    darwinConfigurations."laptop3" = darwinSystem "laptop3";
    nixosConfigurations."server1" = nixosSystem "server1";
    nixosConfigurations."server3" = nixosSystem "server3";

    devShells = forAllSystemsPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # pre-commit
        ];
      };
    });
  };
}
