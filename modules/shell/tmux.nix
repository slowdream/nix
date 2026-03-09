{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    aggressiveResize = true;
    extraConfig = ''
      set -g mouse on
      set -g status-style bg=black,fg=white
    '';
  };
}
