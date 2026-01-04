{ inputs, outputs }:
{
  name,
  path,
  extraModules ? [ ],
  specialArgs ? { },
}:
let
  lib = inputs.nixpkgs.lib;
  hostUtils = import ./hostUtils.nix { inherit lib; };

  deviceConfig = hostUtils.loadDeviceConfig path;
  homeUsersRoot = inputs.self + "/home/users";
  outputsForHM = hostUtils.mkOutputsForHM { inherit outputs inputs; };

  hasHardware = builtins.pathExists "${path}/hardware.nix";
  hasDisko = builtins.pathExists "${path}/disko.nix";

  profileModulePath =
    let
      profile = deviceConfig.profile or null;
      base = ../nixos/profiles;
      directDir = if profile == null then null else "${base}/${profile}";
      directFile = if profile == null then null else "${base}/${profile}.nix";
    in
    if deviceConfig ? profileModulePath then
      deviceConfig.profileModulePath
    else if profile != null && builtins.pathExists directFile then
      directFile
    else if profile != null && builtins.pathExists directDir then
      directDir
    else
      null;

  userSpecs = map hostUtils.normalizeUser (deviceConfig.users or [ ]);

  hmModuleFor =
    user: mode:
    hostUtils.mkHmModulePath {
      inherit homeUsersRoot user;
      os = "nixos";
      hmModuleMode = mode;
    };

  baseModule =
    { lib, ... }:
    {
      imports = [
        ../nixos/modules/device-options.nix
        ../nixos/common
      ];

      device = deviceConfig;
      nixpkgs.hostPlatform = lib.mkDefault (deviceConfig.system or "x86_64-linux");

      users.users = lib.mkMerge (
        map (u: {
          ${u.name} = {
            isNormalUser = lib.mkDefault true;
            extraGroups = lib.mkDefault u.groups;
            packages = lib.mkDefault u.packages;
          };
        }) userSpecs
      );

      home-manager = {
        useUserPackages = lib.mkDefault true;
        extraSpecialArgs = {
          inherit inputs;
          outputs = outputsForHM;
          flakeRoot = inputs.self;
          systemType = deviceConfig.displayServer or null;
          hostConfig.device = deviceConfig;
        };
        users = lib.mkMerge (
          lib.filter (x: x != { }) (
            map (
              u:
              lib.optionalAttrs (u.homeManager.enable or true) {
                ${u.name} = lib.mkDefault (import (hmModuleFor u.name (u.homeManager.module or "auto")));
              }
            ) userSpecs
          )
        );
      };
    };

  modules = [
    baseModule
  ]
  ++ lib.optional hasHardware "${path}/hardware.nix"
  ++ lib.optional hasDisko "${path}/disko.nix"
  ++ lib.optional (profileModulePath != null) profileModulePath
  ++ [ path ]
  ++ extraModules;

  system = deviceConfig.system or "x86_64-linux";
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system modules;
  specialArgs = {
    inherit inputs;
    outputs = outputsForHM;
    systemType = deviceConfig.displayServer or null;
    flakeRoot = inputs.self;
    nixosRoot = inputs.self + /nixos;
    homeRoot = inputs.self + /home;
    inherit homeUsersRoot;
    hostConfig.device = deviceConfig;
    nixosModules = hostUtils.mkModuleTree (inputs.self + /nixos);
  }
  // specialArgs;
}
