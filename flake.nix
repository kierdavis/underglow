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
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              bossa = super.bossa.overrideAttrs (_: {
                src = self.fetchFromGitHub {
                  owner = "arduino";
                  repo = "BOSSA";
                  rev = "37600d1635f830cc0cdf7c56e586a021272c4e35";
                  hash = "sha256-lmeCpHi05G5SH8ue/auzYTwdr//AdnOS8ctQ/IC8AeI=";
                };
              });
            })
          ];
        };

        crossRustTarget = "thumbv7em-none-eabihf";
        crossRust = with fenix.packages.${system};
          combine [
            stable.cargo
            stable.rustc
            targets.${crossRustTarget}.stable.rust-std
          ];
      in rec {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            bossa
            crossRust
            pre-commit
            rumdl
            rustfmt
            pkgsCross.arm-embedded.buildPackages.binutils
          ];
          shellHook = ''export PS1="\n\[\033[1;32m\][underglow]\[\033[0m\] ''${PS1#\\n}"'';
        };

        hydraJobs = {
          inherit devShells;
        };
      }
    );
}
