{
  description = "paiagram-oudia flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" ];
          targets = [
            "x86_64-unknown-linux-gnu"
            "wasm32-unknown-unknown"
          ];
        };

      in
      {
        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "paiagram-oudia";
          version = "0.1.0";
          src = ./.;

          cargoLock.lockFile = ./Cargo.lock;
        };

        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              rustToolchain
              pkg-config
              wasm-bindgen-cli_0_2_114
              just
              binaryen
              stdenv.cc.cc
            ];

            RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
            LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath ([ stdenv.cc.cc ]);
          };
      }
    );
}
