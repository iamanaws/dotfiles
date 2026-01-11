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
// (if endernix != null then import ./minecraft/package.nix { inherit pkgs endernix; } else { })
