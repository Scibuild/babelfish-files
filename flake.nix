{
  description = "System configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cornelis.url = "github:isovector/cornelis?ref=v2.7.0";
    cornelis.inputs.nixpkgs.follows = "nixpkgs";

    
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      cornelis,
      nix-index-database,
      ...
    }:
    let
      system = "x86_64-linux";

      hostname = "babelfish";
      username = "alex";
      homeDirectory = "/home/${username}";
      configHome = "${homeDirectory}/.config";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.xdg.configHome = configHome;
        overlays = [
        ];
      };

    in
    {
      # homeConfigurations = {
      #   main = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [
      #       ./home.nix
      #       {
      #         home = {
      #           inherit homeDirectory username;
      #           stateVersion = "24.05";
      #         };
      #       }
      #     ];
      #   };
      # };

      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./system/configuration.nix

            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [cornelis.overlays.cornelis];
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import ./home.nix {
                inherit homeDirectory username;
              };
            }

            nix-index-database.nixosModules.default
          ];
        };
      };
    };
}

# vim:sw=2:et:ts=2:si:ai
