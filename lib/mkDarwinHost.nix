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
  darwinModules = hostUtils.mkModuleTree (inputs.self + /darwin);
  homeUsersRoot = inputs.self + "/home/users";
  outputsForHM = hostUtils.mkOutputsForHM { inherit outputs inputs; };

  userSpecs = map hostUtils.normalizeUser (deviceConfig.users or [ ]);

  hmModuleFor =
    user: mode:
    hostUtils.mkHmModulePath {
      inherit homeUsersRoot user;
      os = "darwin";
      hmModuleMode = mode;
    };

  # Canonical hostname: lowercase + dash-separated
  hostId =
    let
      rawName = deviceConfig.hostname or name;
    in
    lib.strings.toLower (lib.replaceStrings [ " " "_" "." ] [ "-" "-" "-" ] rawName);

  # UI-facing computer name: CamelCase derived from the hostname
  computerName =
    let
      parts = lib.filter (p: p != "") (lib.strings.splitString "-" hostId);
      cap =
        p:
        let
          lower = lib.strings.toLower p;
          len = builtins.stringLength lower;
        in
        if len <= 1 then
          lib.strings.toUpper lower
        else
          (lib.strings.toUpper (builtins.substring 0 1 lower)) + (builtins.substring 1 (len - 1) lower);
    in
    lib.concatStringsSep "" (map cap parts);

  baseModule =
    { lib, ... }:
    {
      imports = [
        (inputs.self + /nixos/modules/device-options.nix)
        darwinModules.common.default
      ];

      device = deviceConfig;
      nixpkgs.hostPlatform = lib.mkDefault (deviceConfig.system or "x86_64-darwin");

      networking = {
        computerName = lib.mkDefault computerName;
        hostName = lib.mkDefault hostId;
      };

      system.stateVersion = lib.mkDefault (deviceConfig.stateVersion or 6);

      users.users = lib.mkMerge (
        map (u: {
          ${u.name}.home = lib.mkDefault "/Users/${u.name}";
        }) userSpecs
      );

      home-manager = {
        extraSpecialArgs = {
          inherit inputs;
          outputs = outputsForHM;
          systemType = "darwin";
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
    path
  ]
  ++ extraModules;
  system = deviceConfig.system or "x86_64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system modules;
  specialArgs = {
    inherit inputs darwinModules homeUsersRoot;
    outputs = outputsForHM;
    systemType = "darwin";
    flakeRoot = inputs.self;
    darwinRoot = inputs.self + /darwin;
    homeRoot = inputs.self + /home;
    nixosModules = hostUtils.mkModuleTree (inputs.self + /nixos);
  }
  // specialArgs;
}
