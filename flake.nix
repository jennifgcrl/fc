{
  description = "jennifcrl systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/pull/1341/merge";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nix-darwin,
    home-manager,
    ...
  }: let
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
  };
}
