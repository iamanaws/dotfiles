{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  systemType,
  flakeRoot,
  nixosModules,
  homeUsersRoot,
  ...
}:

let
  secrets = flakeRoot + /secrets/daedalus;
  hostUtils = import (flakeRoot + /lib/hostUtils.nix) { inherit lib; };
  userKeys = hostUtils.collectSshKeys { inherit flakeRoot; };
in

{
  imports = [
    secrets
  ]
  ++ (with nixosModules; [
    services.auto-upgrade
    programs.lanzaboote
    services.hardened
  ]);

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    iamanaws = {
      hashedPasswordFile = config.sops.secrets.passwd.path;
      openssh.authorizedKeys.keys = [ userKeys.archimedes.iamanaws ];
    };
  };

  services = {
    getty.autologinUser = lib.mkForce "iamanaws";
  };

}
