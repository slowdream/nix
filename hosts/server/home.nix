{ inputs, config, pkgs, ... }:

{
  imports = [
    ../../lib/defaults.nix
    ../../roles/base.nix
    ../../roles/server.nix
  ];
}
