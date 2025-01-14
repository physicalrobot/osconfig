{
  description = "A NixOS Configuration for tars";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";  # Replace with your actual architecture
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations.tars = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
      ];
    };

    devShell = {
      x86_64-linux = pkgs.mkShell {
        packages = with pkgs; [
          node2nix
          nodejs
          pnpm
          yarn
          pkgs.nodePackages.prettier  # Explicitly reference prettier from nodePackages

          git
          typos
          alejandra
        ];

        shellHook = ''
          echo "Node version: `${pkgs.nodejs}/bin/node --version`"
        '';
      };
    };
  };
}
