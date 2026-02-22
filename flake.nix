{
  inputs = {
    fenix = {
      type = "github";
      owner = "nix-community";
      repo = "fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
    };
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "release-25.11";
    };
  };

  outputs = {
    fenix,
    flake-utils,
    nixpkgs,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};

        crossRustTarget = "thumbv7em-none-eabihf";
        crossRust = with fenix.packages.${system};
          combine [
            stable.cargo
            stable.rustc
            targets.${crossRustTarget}.stable.rust-std
          ];
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            crossRust
            pre-commit
            rumdl
            rustfmt
            pkgsCross.arm-embedded.buildPackages.binutils
          ];
          shellHook = ''export PS1="\n\[\033[1;32m\][underglow]\[\033[0m\] ''${PS1#\\n}"'';
        };
      }
    );
}
