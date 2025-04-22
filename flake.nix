{
  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url  = "github:nix-community/home-manager";
    nix-darwin.url    = "github:LnL7/nix-darwin";   # macOS 用
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }@inputs:
  let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    forAll = f: nixpkgs.lib.genAttrs systems (system: f system);
  in
  {
    # devShell は DevContainer 用に公開
    devShells = forAll (system: {
      default = nixpkgs.legacyPackages.${system}.mkShell {
        packages = [ nixpkgs.legacyPackages.${system}.git ];
      };
    });

    # ホスト毎の home-manager
    homeConfigurations.takao = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ ./home.nix ];
      home.username = "takao";
      home.homeDirectory = "/home/takao";
    };

    # Mac 専用 (nix-darwin)
    darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./darwin.nix ./home.nix ];
    };
  };
}
