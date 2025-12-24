# Custom packages
# build using 'nix build .#example-package'

{ pkgs }:

let
  callPackageDir = dir: pkgs.callPackage (dir + "/package.nix") { };
in
{
  antu-icons = callPackageDir ./antu-icon-theme;
  beekeeper-studio = callPackageDir ./beekeeper-studio;
  dmenu-wpctl = callPackageDir ./dmenu-wpctl;
  dsnote = callPackageDir ./dsnote;
  genai-toolbox = callPackageDir ./genai-toolbox;
  kuyen-icons = callPackageDir ./kuyen-icon-theme;
}
