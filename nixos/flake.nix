{
  description = "A NixOS Configuration for tars";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.tars = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # Replace with your actual architecture
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };

    devShells.default = let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in pkgs.mkShell {
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

      shellHook = ''
        echo "node `${pkgs.nodejs}/bin/node --version`"
      '';
    };
  };
}

