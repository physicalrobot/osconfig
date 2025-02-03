{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nixvim.url = "github:nix-community/nixvim";
    catppuccin.url = "github:catppuccin/nix";
    textfox.url = "github:adriankarlen/textfox";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, home-manager, nixvim, catppuccin, textfox, ... }: 
  let
    inherit (nixpkgs) lib;
    
    # Generate attributes for multiple systems
    forAllSystems = lib.genAttrs lib.systems.flakeExposed;

    # Function to import packages with overlays applied
    importPkgs = path: attrs: import path (attrs // {
      config.allowAliases = false;
      overlays = [ self.overlays.default ];
    });

  in {
    nixosConfigurations = {
      tars = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/nixvim/nixvim.nix

          nixvim.nixosModules.nixvim
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager

          {
            home-manager.users.viku = {
              imports = [
                # nix-doom-emacs.hmModule
                nixvim.homeManagerModules.nixvim
                textfox.homeManagerModules.default  
                ./home.nix
              ];
            };
          }
        ];
      };
    };

    devShell = forAllSystems (system: nixpkgs.legacyPackages.${system}.mkShell {
      packages = with nixpkgs.legacyPackages.${system}; [
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
    });
  };
}

