# desktop.nix
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  nixosModules,
  ...
}:

{
  imports = with nixosModules; [
    profiles.core
    display.default
  ];
}
