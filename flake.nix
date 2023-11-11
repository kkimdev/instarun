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
            # TODO: Migrate the followings
            # curl?
            pkgs.bash
            pkgs.git
            pkgs.rustup
          ];

          shellHook = with pkgs; ''
          '';
        };
      }
    );
}
