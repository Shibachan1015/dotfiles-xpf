{
  description = "Dotfiles managed by Nix Flakes + Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
  let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
  {
    # DevShell for development
    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = with nixpkgs.legacyPackages.${system}; [ git chezmoi ];
      };
    });

    # WSL/Linux Home Manager configuration
    homeConfigurations = {
      "takasiba" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home/default.nix
          ./home/wsl.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };

      "takao" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./home/default.nix
          ./home/wsl.nix
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };

    # macOS configuration with nix-darwin
    darwinConfigurations = {
      "MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.takao = import ./home/darwin-home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
