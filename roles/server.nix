{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    iotop
    ncdu
    jq
  ];

  xdg.enable = false;
  targets.genericLinux.enable = true;
}
