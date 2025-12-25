{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:

{
  nix = {
    enable = true;
    package = pkgs.lixPackageSets.stable.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@admin" ];
    };

    optimise.automatic = config.nix.enable;

    gc = {
      automatic = config.nix.enable;
      options = "--delete-older-than 14d";
      interval = [ { Hour = 2; } ];
    };

    # Run GC when there is less than 100MiB left.
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.config.permittedInsecurePackages = import (flakeRoot + /lib/permittedInsecurePackages.nix);
}
