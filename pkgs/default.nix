# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

let
  callPackageDir = dir: pkgs.callPackage (dir + "/package.nix") { };
in
{
  dmenu-wpctl = callPackageDir ./dmenu-wpctl;
  dsnote = callPackageDir ./dsnote;
  genai-toolbox = callPackageDir ./genai-toolbox;
}
