{ config, pkgs, ... }:

{
  imports = [
    ../modules/shell/zsh.nix
    ../modules/dev/editors.nix
    ../modules/cli/ripgrep.nix
  ];

  home.packages = with pkgs; [
    git
    btop
    zellij
    unzip
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file.".config/zellij/config.kdl".source = ../home/zellij/config.kdl;
}
