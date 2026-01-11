# Custom packages
# build using 'nix build .#example-package'

{
  pkgs,
  endernix ? null,
}:

let
  callPackageDir = dir: pkgs.callPackage (dir + "/package.nix") { };
in
{
  dmenu-wpctl = callPackageDir ./dmenu-wpctl;
  dsnote = callPackageDir ./dsnote;
  genai-toolbox = callPackageDir ./genai-toolbox;
}
// pkgs.lib.optionalAttrs (endernix != null) (
  pkgs.callPackage ./minecraft/package.nix { inherit endernix; }
)
