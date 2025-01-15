{description = "A NixOS Configuration for tars";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  textfox.url = "github:adriankarlen/textfox";
};

outputs = inputs@{ self, nixpkgs, home-manager, textfox, ... }: let
  system = "x86_64-linux"; # Replace with your actual architecture
  pkgs = nixpkgs.legacyPackages.${system};
in {
  nixosConfigurations.tars = nixpkgs.lib.nixosSystem {
    system = system;
    specialArgs = { inherit inputs system; };
    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      home-manager.nixosModules.home-manager
      {
        # Enable home-manager integration
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        # Define user home-manager configuration
        home-manager.users.viku = {
          imports = [
            ./home.nix
            inputs.textfox.homeManagerModules.default
          ];
        };
      }
    ];
  };

  devShell = {
    x86_64-linux = pkgs.mkShell {
      packages = with pkgs; [
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

