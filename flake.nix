{
  inputs = {
    # Track `nixpkgs-unstable` branch instead of the default branch to avoid
    # package build cache misses.
    # https://discourse.nixos.org/t/nix-flakes-input-repository-branches-conventions/26772/2
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.bashInteractive
            pkgs.git
            pkgs.cargo
            pkgs.pkg-config
            pkgs.openssl
          ];

          shellHook = with pkgs; ''
          '';
        };
      }
    );
}
