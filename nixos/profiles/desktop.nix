# desktop.nix
{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  nixosModules,
  ...
}:

{
  imports = with nixosModules; [
    profiles.core
    display.default
  ];
}
