{
# TODO: Make this flake working

  description = "TestCompiler Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
          conan
          cmake
          gnumake
          git
          ninja
        ];
      };
    };
}
