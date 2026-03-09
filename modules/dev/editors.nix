{ inputs, config, pkgs, lib, ... }:

let
  nvm = pkgs.fetchFromGitHub {
    owner = "nvm-sh";
    repo = "nvm";
    rev = "v0.40.4";
    sha256 = "9361c271d2589569f55779ae36b51c5ee4fc5a3bec9c4fcf3b5d8fafb47915fa";
  };
in
{
  imports = [
    inputs.nix4nvchad.homeManagerModule
  ];

  programs.nvchad = {
    enable = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      docker-compose-language-service
      dockerfile-language-server
      emmet-language-server
      nixd
    ];
    hm-activation = true;
    backup = false;
  };

  home.activation.setupNvm = lib.hm.dag.entryAfter ["writeBoundary"] ''
    export PATH="${pkgs.curl}/bin:${pkgs.wget}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.coreutils}/bin:$PATH"
    export NVM_DIR="$HOME/.nvm"
    mkdir -p "$NVM_DIR"
    rm -rf "$NVM_DIR/.git" 2>/dev/null || true
    chmod -R u+rwX "$NVM_DIR" 2>/dev/null || true
    tar -cf - -C ${nvm} --exclude='test' --exclude='.git' . 2>/dev/null | tar -xf - -C "$NVM_DIR" 2>/dev/null || true
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts
    if [ ! -f "$NVM_DIR/alias/default" ]; then
      nvm alias default 'lts/*'
    fi
  '';

  programs.zsh = {
    initContent = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    '';
    oh-my-zsh.plugins = [ "git" "nvm" ];
  };
}
