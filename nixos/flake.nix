{
  description = "Modular NixOS Configuration with Separate Home Manager";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      tars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };

    homeConfigurations = {
      viku = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [ ./home.nix ];
      };
    };

    devShell = {
      x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".mkShell {
        packages = with nixpkgs.legacyPackages."x86_64-linux"; [
          node2nix
          nodejs
          pnpm
          yarn
          pkgs.nodePackages.prettier
          git
          typos
        ];
      };
    };
  };
}

