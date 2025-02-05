{
  description = "NixOS and Home Manager configuration";

  inputs = {
    home-manager.url = "github:rycee/home-manager";
    nixvim.url = "github:nix-community/nixvim";
    catppuccin.url = "github:catppuccin/nix";
    textfox.url = "github:adriankarlen/textfox";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
    nur.url = "github:nix-community/NUR";
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
	  ./modules/nixvim/plugins/all.nix

          nixvim.nixosModules.nixvim
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";  # <--- This automatically renames conflicting files
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
              textfox.homeManagerModules.default  
              ];
            home-manager.users.viku = import ./home.nix;
          }
        ];
      };
    };

    homeConfigurations.viku = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit nixpkgs; };
      modules = [
        nixvim.homeManagerModules.nixvim
        textfox.homeManagerModules.default
        ./home.nix
      ];
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
        python3
        python3Packages.pip
        python3Packages.virtualenv
        python3Packages.wheel
        python3Packages.setuptools 
        postgresql
        postgresql_13
        libxslt
        libzip
        openldap
        cyrus_sasl
        libxml2
        libjpeg
        wget
        wkhtmltopdf
        sassc
      ];
    });
  };
}
