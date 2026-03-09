{
  description = "Home Manager configuration with zsh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad-starter = {
      url = "path:./nvchad-starter";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
  };


  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";   # замените на aarch64-linux, если нужно
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations = {
        "slowdream@server" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/server/home.nix
          ];
        };
      };
    };
}