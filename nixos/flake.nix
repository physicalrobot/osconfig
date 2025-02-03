{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs,
    nixvim,
    catppuccin,
    ...
  }: {
  
    nixosConfigurations = {
      tars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix 
          ./modules/nixvim/nixvim.nix
          nixvim.nixosModules.nixvim
          catppuccin.nixosModules.catppuccin

          # Integrate Home Manager inside the system
          home-manager.nixosModules.home-manager

          # User-specific configurations inside NixOS
          {
            home-manager.users.viku = {
              imports = [ ./modules/doom/doom.nix ];  # Import Doom from .dotfiles/nixos/modules/doom
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
