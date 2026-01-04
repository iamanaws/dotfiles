# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

let
  callPackageDir = dir: pkgs.callPackage (dir + "/package.nix") { };
in
{
  beekeeper-studio = callPackageDir ./beekeeper-studio;
  dmenu-wpctl = callPackageDir ./dmenu-wpctl;
  dsnote = callPackageDir ./dsnote;
  genai-toolbox = callPackageDir ./genai-toolbox;
  skia-aseprite = callPackageDir ./skia-aseprite;
  aseprite = callPackageDir ./aseprite;
}
