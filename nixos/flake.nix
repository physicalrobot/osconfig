{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
 };


  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs,
    nixvim,
    ...
  }: {
    nixosConfigurations = {
      tars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/home/nixvim.nix
          nixvim.homeManagerModules.nixvim
          # Integrate Home Manager for the system
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      viku = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home.nix

          # Add Doom Emacs for the user
          {
            imports = [ nix-doom-emacs.hmModule ];
            programs.doom-emacs = {
              enable = true;
              doomPrivateDir = ./doom.d;
            };
          }
        ];
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
          
          ruby
          gcc
          
        ];
      };
    };
  };
}

