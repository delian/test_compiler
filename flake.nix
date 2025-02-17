{
  description = "TestCompiler Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      ply = (with pkgs; stdenv.mkDerivation {
          pname = "ply";
          version = "0.0.1";
          src = ./.;
          nativeBuildInputs = [
            clang
            cmake
            ninja
            conan
            gcc
            gcovr
            gdb
          ];
          buildPhase = ''
            conan profile detect
            cmake -S . -B build -G Ninja
            cmake --build build
          '';
          installPhase = ''
            mkdir -p $out/bin
          '';
        }
      );
    in rec {
      apps.default = flake-utils.lib.mkApp {
        drv = packages.default;
      };
      packages.default = ply;
      devShells.default = pkgs.mkShell {
        buildInputs = [
          ply
        ];
      };
    }
  );

}
