# Mod declarations for Modrinth
# Run `nix run .#update-mods -- pkgs/minecraft/mods.nix` to generate mods.lock.nix
let
  gameVersion = "1.21.1";
in
builtins.mapAttrs (_: _: { inherit gameVersion; }) {
  balm = { };
  cardinal-components-api = { };
  cloth-config = { };
  cobblemon = { };
  cobblemon-smartphone = { };
  fabric-api = { };
  fabric-language-kotlin = { };
  inventory-profiles-next = { };
  jei = { };
  libipn = { };
  trashslot = { };
  travelersbackpack = { };
}
