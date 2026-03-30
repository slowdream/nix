{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      sail="sh $([ -f sail ] && echo sail || echo vendor/bin/sail)";
      hm="home-manager switch --flake ~/.config/home-manager#slowdream@server";
    };
    history.size = 10000;
    initContent = ''
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };
}
