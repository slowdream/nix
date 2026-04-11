{ config, pkgs, username, host, ... }:
let
  artisan-src = pkgs.fetchgit {
    url = "https://github.com/jessarcher/zsh-artisan.git";
    rev = "HEAD";
    sha256 = "sha256-O0Tn9zQWR0i7UWJ9VtOvxjqpqz9Sj7aKogdHZSOATC0=";
  };
in
{
  home.file.".p10k.zsh".source = ../../home/zsh/p10k.zsh;

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
      sail = "sh $([ -f sail ] && echo sail || echo vendor/bin/sail)";
      hm = "home-manager switch --flake ~/.config/home-manager#${username}@${host}";
    };
    history.size = 10000;

    initContent = ''
      if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
      fi
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      export NVM_DIR="$HOME/.nvm"
      export TMPDIR="''${TMPDIR:-/tmp}"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    '';

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "artisan";
        src = artisan-src;
      }
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "nvm" ];
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export NVM_DIR="$HOME/.nvm"
      export TMPDIR="''${TMPDIR:-/tmp}"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    '';
  };
}
