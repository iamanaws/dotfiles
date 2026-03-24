{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  flakeRoot,
  nixosModules,
  ...
}:

let
  secrets = flakeRoot + /secrets;
in

{
  imports = [
    secrets
  ]
  ++ (with nixosModules; [
    programs.lanzaboote
    services.hardened
    services.automount
  ]);

  environment.systemPackages = with pkgs; [
    # dsnote
    mongodb-compass
    postman
    # remmina
  ];

}
