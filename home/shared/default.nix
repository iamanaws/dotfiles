{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  disabledModules = [
    "programs/zed-editor.nix"
  ];

  imports = [
    ./programs/zed-editor.nix
  ];

}
