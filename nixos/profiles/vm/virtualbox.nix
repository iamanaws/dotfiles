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

  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
}
