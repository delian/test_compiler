{
# TODO: Make this flake working

  description = "TestCompiler Nix Flake";

  inputs = {
    nixurl = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "testcompiler";
        nativeBuildInputs = with pkgs; [
          clang
          cmake
          git
          ninja
        ];
      };
    };
}
