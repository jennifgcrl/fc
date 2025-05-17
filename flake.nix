{
  description = "jennifcrl systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
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

    darwinSystem = system: extraModules: hostName:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = {
          inherit self nix-darwin;
        };
        modules =
          [
            ./darwin.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.jennifer = import ./home.nix;
            }
          ]
          ++ extraModules;
      };
  in {
    darwinConfigurations."laptop3" = darwinSystem "aarch64-darwin" [] "laptop3";

    devShells = forAllSystemsPkgs (pkgs: {
      default = pkgs.mkShell {
        packages = [
        ];
      };
    });
  };
}
