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
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    lanzaboote,
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

    darwinSystem = hostName: extraModules:
      nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit self nix-darwin hostName;
        };
        modules =
          [
            ./hosts/${hostName}

            home-manager.darwinModules.home-manager
            {
              home-manager.users.jennifer = import ./home.nix;
            }
          ]
          ++ extraModules;
      };

    nixosSystem = hostName: extraModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit self nixpkgs hostName;
        };
        modules =
          [
            lanzaboote.nixosModules.lanzaboote

            ./hosts/${hostName}

            home-manager.nixosModules.home-manager
            {
              home-manager.users.jennifer = import ./home.nix;
            }
          ]
          ++ extraModules;
      };
  in {
    darwinConfigurations."laptop3" = darwinSystem "laptop3" [];
    nixosConfigurations."server1" = nixosSystem "server1" [];
    nixosConfigurations."server3" = nixosSystem "server3" [];

    devShells = forAllSystemsPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = [
        ];
      };
    });
  };
}
