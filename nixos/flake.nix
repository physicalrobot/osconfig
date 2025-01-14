{
  description = "A Nix-flake-based Node.js development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    pre-commit-hooks,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        (self: super: rec {
          nodejs = super.nodejs_20;
          pnpm = super.pnpm.override { inherit nodejs; };
          yarn = super.yarn.override { inherit nodejs; };
          prettier = super.nodePackages.prettier;
        })
      ];
      pkgs = import nixpkgs { inherit overlays system; };
      pkgs_chromium = import nixpkgs { inherit system; };
      packages = with pkgs; [
        node2nix
        nodejs
        pnpm
        yarn
        prettier

        git
        typos
        alejandra
      ];
    in {
      devShells.default = pkgs.mkShell {
        inherit packages;
        shellHook = ''
          echo "node `${pkgs.nodejs}/bin/node --version`"
        '';
      };
    });
}

