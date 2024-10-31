{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nixpkgs-stable, ... }:
    let
      nixosConfigurations =
        let
          system = "x86_64-linux";
          user = "user";
          overlays-nixpkgs = final: prev: {
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
          };
        in
          { default = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs user; };
                modules = [
                  ./configuration.nix
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = {
                      inherit user;
                      nixosConfig = self.nixosConfigurations.default.config;
                    };
                    home-manager.users.${user} = import ./home.nix;
                  }

                  ({ ... }: { nixpkgs.overlays = [ overlays-nixpkgs ]; })
                ];
              };
            };
    in

    {
      inherit nixosConfigurations;
    };

}
