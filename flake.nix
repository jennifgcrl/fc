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

    niri.url = "github:sodiboo/niri-flake";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    lanzaboote,
    niri,
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
          inherit self hostName home-manager lanzaboote niri;
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
        packages = [
        ];
      };
    });
  };
}
