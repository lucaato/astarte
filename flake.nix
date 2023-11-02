{
  description = "Astarte helper shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    astartectl = {
      type = "github";
      owner = "astarte-platform";
      repo = "astartectl";
      ref = "release-23.5";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, astartectl, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ import astartectl.overlays.${system}.default ];
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          packages = [
            astartectl
            docker
            docker-compose
          ];
        };
      }
    );
}
