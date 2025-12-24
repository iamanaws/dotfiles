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
in

{
  imports = with nixosModules; [
    secrets
    services.auto-upgrade
    programs.lanzaboote
    services.hardened
  ];

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    iamanaws = {
      hashedPasswordFile = config.sops.secrets.passwd.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvjMCx6qhx8/wWEuALzeQ5PTX+0oq8o5Le0MAmvg97p iamanaws@archimedes"
      ];
    };
  };

  services = {
    getty.autologinUser = lib.mkForce "iamanaws";
  };

}
