{
  description = "iamanaws' nix flake";

  inputs = {
    #### Nixpkgs ####

    # Nixpkgs source, pinned for the entire system
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #### NIXOS ####

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    #### DARWIN ####

    nix-darwin = {
      # url = "github:LnL7/nix-darwin";
      url = "github:Iamanaws/nix-darwin/controlcenter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    #### Home manager ####
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # nix-colors.url = "github:misterio77/nix-colors";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      hosts = import ./hostnames.nix { inherit inputs; };

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      formatter = forAllSystems ({ pkgs }: pkgs.nixfmt-tree);
      packages = forAllSystems ({ pkgs }: import ./pkgs { inherit pkgs; });
      overlays = import ./overlays { inherit inputs; };

      ### NixOS Configurations ###
      nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.nixos) (
        hostName:
        let
          host = hosts.nixos.${hostName};
        in
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
            systemType = if host ? systemType then host.systemType else null;
          };
          modules = host.modules;
        }
      );

      ### Darwin Configurations ###
      darwinConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames hosts.darwin) (
        hostName:
        let
          host = hosts.darwin.${hostName};
        in
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs outputs;
            systemType = if host ? systemType then host.systemType else "darwin";
          };
          modules = host.modules;
        }
      );
    };
}
