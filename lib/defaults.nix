{ config, pkgs, ... }:

{
  home.username = "slowdream";
  home.homeDirectory = "/home/slowdream";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;
}
