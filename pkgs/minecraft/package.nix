{
  pkgs,
  endernix,
}:

let
  inherit (endernix.lib) mkInstance modrinth;
  minecraftPkgs = endernix.minecraft.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  cobblemon = mkInstance {
    inherit pkgs minecraftPkgs;
    name = "cobblemon";
    version = "1_21_1";
    loader = "fabric";
    mods = modrinth.fromLockFile ./mods.lock.nix;
  };
}
