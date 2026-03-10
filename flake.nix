{
  description = "Home Manager configuration with zsh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "slowdream";
      host = "server";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        "${username}@${host}" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs username host; };
          modules = [ ./hosts/server/home.nix ];
        };
      };
    };
}