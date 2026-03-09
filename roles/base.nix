{ config, pkgs, ... }:

{
  imports = [
    ../modules/shell/zsh.nix
    ../modules/shell/p10k.nix
    ../modules/shell/tmux.nix
    ../modules/dev/editors.nix
    ../modules/cli/ripgrep.nix
  ];

  home.packages = with pkgs; [
    git
    htop
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
