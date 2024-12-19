{
  description = "Dolphin's NetPlay Index / Lobby Server";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.poetry2nix.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, poetry2nix }: {
    overlay = nixpkgs.lib.composeManyExtensions [
      # Manually override wheel package to 0.45.1 until the change lands in nixos-24.11
      # https://github.com/NixOS/nixpkgs/pull/361930
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            wheel = python-prev.wheel.overrideAttrs (oldAttrs: {
              version = "0.45.1";
              
              src = oldAttrs.src.override {
                rev = "refs/tags/0.45.1";
                hash = "sha256-tgueGEWByS5owdA5rhXGn3qh1Vtf0HGYC6+BHfrnGAs=";
              };
            });
          })
        ];
      })
      poetry2nix.overlays.default
      (final: prev: {
        netplay-index = prev.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
          checkPhase = "GEOIP_DATABASE_PATH=testdata/GeoLite2-Country.mmdb ASYNC_TEST_TIMEOUT=30 pytest";
        };
      })
    ];
  } // (flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in rec {
      packages.netplay-index = pkgs.netplay-index;
      defaultPackage = pkgs.netplay-index;

      devShells.default = with pkgs; mkShell {
        buildInputs = [ python3Packages.poetry ];
      };
    }
  ));
}
