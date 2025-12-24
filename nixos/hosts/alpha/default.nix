{
  inputs,
  outputs,
  config,
  lib,
  modulesPath,
  pkgs,
  flakeRoot,
  nixosModules,
  homeUsersRoot,
  ...
}:

let
  secrets = flakeRoot + /secrets;
in

{
  imports = with nixosModules; [
    secrets
    programs.nix
  ];

  users.users = {
    iamanaws = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvjMCx6qhx8/wWEuALzeQ5PTX+0oq8o5Le0MAmvg97p iamanaws@archimedes"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wpa_supplicant
    vim
  ];

  networking = {
    interfaces."wlan0".useDHCP = true;
    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];

      # Networks defined in aux imperitive networks (/etc/wpa_supplicant.conf)
      userControlled.enable = true;
      allowAuxiliaryImperativeNetworks = true;
    };
    # override core defaults
    networkmanager.enable = lib.mkForce false;
  };

  # Link /etc/wpa_supplicant.conf -> secret config
  environment.etc."wpa_supplicant.conf" = {
    source = config.sops.secrets.wireless.path;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services = {
    getty.autologinUser = lib.mkForce "iamanaws";
    openssh.enable = true;
    timesyncd.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  # Some packages (ahci fail... this bypasses that) https://discourse.nixos.org/t/does-pkgs-linuxpackages-rpi3-build-all-required-kernel-modules/42509
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

}
