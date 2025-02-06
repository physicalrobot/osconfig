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
   
    # Function to get pkgs for a given system 
    pkgsFor = system: import nixpkgs {
      system = system;
      config.allowUnfree = true;
    }; 

    # Import dev-packages and apply them per system
    devPackagesFor = system: import ./dev-packages.nix { pkgs = pkgsFor system; };

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

      digivice = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";  # ARM64 for RK3588 chip
        modules = [
          ./configuration.nix  # You may want to create a separate ./digivice-configuration.nix for ARM-specific settings
          ./modules/nixvim/nixvim.nix
          ./modules/nixvim/plugins/all.nix

          nixvim.nixosModules.nixvim
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";  
            home-manager.sharedModules = [
              nixvim.homeManagerModules.nixvim
              textfox.homeManagerModules.default  
            ];
            home-manager.users.viku = import ./home.nix;
          }

          {
            # Hardware-specific settings for MNT Pocket Reform
            boot.kernelPackages = nixpkgs.legacyPackages.aarch64-linux.linuxPackages_latest;
            hardware.opengl.enable = true;
            powerManagement.enable = true;
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

  devShells = forAllSystems (system: {
        default = (pkgsFor system).mkShell {
        packages = devPackagesFor system;
      };
    }); 
  };
}
