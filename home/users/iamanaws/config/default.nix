{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  hostConfig,
  ...
}:
{
  imports = [
    ./shell
    ./kitty.nix
    ./dunst
    ./hypr
    ./cursor.nix
  ];
}
