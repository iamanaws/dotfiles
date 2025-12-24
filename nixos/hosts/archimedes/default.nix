{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  flakeRoot,
  nixosModules,
  ...
}:

let
  secrets = flakeRoot + /secrets;
in

{
  imports = with nixosModules; [
    secrets
    programs.lanzaboote
    services.hardened
    services.automount
  ];

  environment.systemPackages = with pkgs; [
    # dsnote
    mongodb-compass
    postman
    # remmina
  ];

}
