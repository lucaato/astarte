{
  description = "Astarte helper shell";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: 
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        astartectl =
          let
            version = "23.5.0";
          in
          pkgs.buildGoModule {
            inherit version;
            pname = "astartectl";
            src = pkgs.fetchFromGitHub {
              owner = "astarte-platform";
              repo = "astartectl";
              rev = "v${version}";
              sha256 = "sha256-4NgDVuYEeJI5Arq+/+xdyUOBWdCLALM3EKVLSFimJlI=";
            };
            vendorSha256 = "sha256-Syod7SUsjiM3cdHPZgjH/3qdsiowa0enyV9DN8k13Ws=";
            # Completion
            nativeBuildInputs = with pkgs; [
              installShellFiles
            ];
            postInstall = ''
              installShellCompletion --cmd astartectl \
                --bash <($out/bin/astartectl completion bash) \
                --zsh <($out/bin/astartectl completion zsh) \
                --fish <($out/bin/astartectl completion fish)
            '';
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
