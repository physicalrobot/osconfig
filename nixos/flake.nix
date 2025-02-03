{
  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    catppuccin.url = "github:catppuccin/nix";
    textfox.url = "github:adriankarlen/textfox";  
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-doom-emacs,
    nixvim,
    catppuccin,
    textfox,
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

          home-manager.nixosModules.home-manager

          # ✅ Fix: Ensure proper structure for Home Manager
          {
          home-manager.users.viku = {
              imports = [
                nix-doom-emacs.hmModule
                nixvim.homeManagerModules.nixvim
                textfox.homeManagerModules.default  
                ./home.nix
              ];
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
