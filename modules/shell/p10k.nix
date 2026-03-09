{ config, pkgs, ... }:
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

  programs.zsh.plugins = [
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

  programs.zsh.initContent = ''
    [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
  '';
}
